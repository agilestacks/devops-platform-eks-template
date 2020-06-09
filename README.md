# ASI Kubernetes Platform Stack template in AWS

## Quick Start

Prerequisites: Mac OS or Linux, Docker

1. Download & Install the Automation Hub binary. Instructions are available here: [HUB CLI](https://docs.agilestacks.com/article/zrban5vpb5-install-toolbox)
2. (Optional) Run `toolbox` Docker image that contains all required tools for provisioning (AWS CLI, Terraform, kubectl, Helm, etc.): `hub toolbox`. You can deploy the stack without the `toolbox`, however in this case all required tools (with correct versions) must be installed on your workstation. Please refer to [Toolbox repo in GitHub](https://github.com/agilestacks/toolbox) to see what tools are required in order to deploy stacks.
3. Run `hub configure` to setup environment. More details to follow...
4. Run `hub ext deploy` to deploy the stack template. More details to follow...
5. Run `hub ext undeploy` to undeploy the stack template
