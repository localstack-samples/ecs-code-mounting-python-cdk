import setuptools


with open("README.md") as fp:
    long_description = fp.read()

setuptools.setup(
    name="cdk_ecs_example",
    version="0.0.1",
    long_description=long_description,
    long_description_content_type="text/markdown",
    package_dir={"": "cdk_ecs_example"},
    packages=setuptools.find_packages(where="cdk_ecs_example"),
    install_requires=[
        "aws-cdk.core==1.92.0",
        "aws-cdk.aws-ec2==1.92.0",
        "aws-cdk.aws-ecs==1.92.0",
        "aws-cdk.aws-ecs-patterns==1.92.0",
    ],
    python_requires=">=3.9",
)
