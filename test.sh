#!/bin/bash
# Call the Flask service through the load balancer, then change service/main.py
# on the host and check the running ECS tasks pick up the change through the
# mounted volume, without a redeploy.
set -euo pipefail

STACK=CdkEcsExample
MAIN=service/main.py
MAX_ATTEMPTS=${MAX_ATTEMPTS:-40}

LB_DNS=$(lstk aws cloudformation describe-stacks --stack-name "$STACK" \
  --query "Stacks[0].Outputs[?starts_with(OutputKey, 'DemoServiceLoadBalancerDNS')].OutputValue | [0]" --output text)
URL="http://$LB_DNS:4566"
echo "Service URL: $URL"

# Wait until the tasks are up and serving
response=""
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  response=$(curl -s -m 5 "$URL/" || true)
  [ "$response" = "Hello, LocalStack!" ] && break
  echo "Attempt $attempt/$MAX_ATTEMPTS: service not ready yet"
  sleep 3
done
if [ "$response" != "Hello, LocalStack!" ]; then
  echo "Test failed: GET / returned '$response'"
  exit 1
fi
echo "PASS: GET / returned '$response'"

response=$(curl -s -m 5 -X POST "$URL/post" -H 'Content-Type: application/json' -d '{"source": "ci"}')
if [[ "$response" != *"Received data: {'source': 'ci'}"* ]]; then
  echo "Test failed: POST /post returned '$response'"
  exit 1
fi
echo "PASS: POST /post returned '$response'"

restore() {
  git checkout -- "$MAIN"
}
trap restore EXIT

echo "Changing $MAIN on the host"
sed -i.bak 's/Hello, LocalStack!/Hello, code mounting!/' "$MAIN" && rm -f "$MAIN.bak"

# Both tasks mount the same directory, so every response should change
for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  response=$(curl -s -m 5 "$URL/" || true)
  if [ "$response" = "Hello, code mounting!" ]; then
    echo "PASS: GET / returned '$response' after the change"
    echo "Test passed: the service reloaded the mounted code"
    exit 0
  fi
  echo "Attempt $attempt/$MAX_ATTEMPTS: still getting '$response'"
  sleep 3
done

echo "Test failed: the code change was not picked up"
exit 1
