# ECS Code Mounting with AWS CDK in Python

| Key          | Value                                                                                 |
| ------------ | ------------------------------------------------------------------------------------- |
| Environment  | <img src="https://img.shields.io/badge/LocalStack-deploys-4D29B4.svg?logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAKgAAACoABZrFArwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAALbSURBVHic7ZpNaxNRFIafczNTGIq0G2M7pXWRlRv3Lusf8AMFEQT3guDWhX9BcC/uFAr1B4igLgSF4EYDtsuQ3M5GYrTaj3Tmui2SpMnM3PlK3m1uzjnPw8xw50MoaNrttl+r1e4CNRv1jTG/+v3+c8dG8TSilHoAPLZVX0RYWlraUbYaJI2IuLZ7KKUWCisgq8wF5D1A3rF+EQyCYPHo6Ghh3BrP8wb1en3f9izDYlVAp9O5EkXRB8dxxl7QBoNBpLW+7fv+a5vzDIvVU0BELhpjJrmaK2NMw+YsIxunUaTZbLrdbveZ1vpmGvWyTOJToNlsuqurq1vAdWPMeSDzwzhJEh0Bp+FTmifzxBZQBXiIKaAq8BBDQJXgYUoBVYOHKQRUER4mFFBVeJhAQJXh4QwBVYeHMQJmAR5GCJgVeBgiYJbg4T8BswYPp+4GW63WwvLy8hZwLcd5TudvBj3+OFBIeA4PD596nvc1iiIrD21qtdr+ysrKR8cY42itCwUP0Gg0+sC27T5qb2/vMunB/0ipTmZxfN//orW+BCwmrGV6vd63BP9P2j9WxGbxbrd7B3g14fLfwFsROUlzBmNM33XdR6Meuxfp5eg54IYxJvXCx8fHL4F3w36blTdDI4/0WREwMnMBeQ+Qd+YC8h4g78wF5D1A3rEqwBiT6q4ubpRSI+ewuhP0PO/NwcHBExHJZZ8PICI/e73ep7z6zzNPwWP1djhuOp3OfRG5kLROFEXv19fXP49bU6TbYQDa7XZDRF6kUUtEtoFb49YUbh/gOM7YbwqnyG4URQ/PWlQ4ASllNwzDzY2NDX3WwioKmBgeqidgKnioloCp4aE6AmLBQzUExIaH8gtIBA/lFrCTFB7KK2AnDMOrSeGhnAJSg4fyCUgVHsolIHV4KI8AK/BQDgHW4KH4AqzCQwEfiIRheKKUAvjuuu7m2tpakPdMmcYYI1rre0EQ1LPo9w82qyNziMdZ3AAAAABJRU5ErkJggg=="> <img src="https://img.shields.io/badge/AWS-deploys-F29100.svg?logo=amazon">                                                                     |
| Services     | Elastic Container Service, Elastic Container Registry                                 |
| Integrations | CDK                                                                            |
| Categories   | Containers                                                  |
| Level        | Beginner                                                                            |
| GitHub       | [Repository link](https://github.com/localstack-samples/ecs-code-mounting-python-cdk)   |

## Introduction

The ECS Code Mounting feature allows you to mount code from your host filesystem into the ECS container. This enables a quick debugging loop where you can test changes without having to build and redeploy the ECS task’s Docker image and push it to ECR each time. Internally, LocalStack uses the [AWS Bind Mounts](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/bind-mounts.html) to implement the ECS Code Mounting feature.

The sample code in this repository demonstrates how to use the ECS Code Mounting feature with AWS CDK in Python. The ECS task uses a simple Flask application that returns a simple message. The code is mounted from the host filesystem into the ECS container, and the ECS task is deployed to a LocalStack environment.

![image](images/demo.gif)

## Prerequisites

- LocalStack Pro with the [`localstack` CLI](https://docs.localstack.cloud/getting-started/installation/#localstack-cli).
- [Cloud Development Kit](https://docs.localstack.cloud/user-guide/integrations/aws-cdk/) with the [`cdklocal`](https://www.npmjs.com/package/aws-cdk-local) installed.
- [Python 3.9+](https://www.python.org/downloads/) & `pip` package manager.
- [`virtualenv`](https://pypi.org/project/virtualenv/) for creating isolated Python environments.
- `cURL` or any other tool to send HTTP requests.

Start LocalStack Pro with the `LOCALSTACK_AUTH_TOKEN` pre-configured:

```shell
export LOCALSTACK_AUTH_TOKEN=<your-auth-token>
localstack start
```

## Instructions

In this section, you'll learn how to deploy the CDK stack to LocalStack and test the ECS Code Mounting feature.

### Installing dependencies

To install the dependencies, run the following command:

```bash
virtualenv env
source env/bin/activate # On Windows, use `env\Scripts\activate`
pip install -r requirements.txt
```

### Deploying the CDK stack

To bootstrap the CDK, run the following command:

```shell
cdklocal bootstrap
```

To deploy the infrastructure, run the following command:

```shell
cdklocal deploy
```

You are expected to see the following output:

```bash
 ✅  CdkEcsExample

✨  Deployment time: 16.8s

Outputs:
CdkEcsExample.DemoServiceLoadBalancerDNS00F01F2F = lb-2cf5d58c.elb.localhost.localstack.cloud
CdkEcsExample.DemoServiceServiceURL823541D5 = http://lb-2cf5d58c.elb.localhost.localstack.cloud
Stack ARN:
arn:aws:cloudformation:us-east-1:000000000000:stack/CdkEcsExample/c8aa4bea

✨  Total time: 18.08s
```

### Testing the ECS deployment

Navigate to the LocalStack logs and you would be able to see the following logs:

```bash
2024-04-10T15:32:47.025  WARN --- [   asgi_gw_1] l.s.e.t.docker             : Updating hostPort for ECS task to 19344, as requested host port 28099 seems unavailable
```

To test the ECS deployment, run the following command:

```shell
curl localhost:28099
```

You are expected to see the following output:

```bash
Hello, LocalStack!
```

### Testing the ECS Code Mounting feature

Go to the `service/main.py` file and change the message on line 8 to `Hello, ECS Code Mounting!`. Save the file.

```python3
@app.route("/")
def hello_world():
    return "Hello, ECS Code Mounting!"
```

Save the file and run the following command to test the code mounting feature:

```shell
curl localhost:28099
```

You are expected to see the following output:

```bash
Hello, ECS Code Mounting!
```

### Cleaning up

To clean up the resources, run the following command:

```shell
localstack stop
```

## How do I set up the ECS Code Mounting feature?

To use this example, you need to set up the ECS Code Mounting feature in the ECS task definition. The following code snippet demonstrates how to set up the ECS Code Mounting feature in the CDK stack:

```python
task_definition = ecs.FargateTaskDefinition(
    self,
    "DemoServiceTask",
    family="DemoServiceTask",
    volumes=[
        ecs.Volume(
            name="test-volume",
            host=ecs.Host(
                source_path=os.path.join(os.getcwd(), "service")
            ),
        )
    ],
)
...
container.add_mount_points(
    ecs.MountPoint(
        container_path="/app",
        source_volume="test-volume",
        read_only=True
    ),
)
```

In the above snippet, you need to create a volume with the `source_path` pointing to the directory containing the code that you want to mount (in this case, the `service` directory). Then, you need to add a mount point to the container with the `container_path` pointing to the directory inside the container where you want to mount the code (in this case, the `/app` directory).

## License

This library is licensed under the Apache 2.0 License.
