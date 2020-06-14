# Agile Stacks DevOps platform on EKS

`Agile Stacks DevOps platform on EKS` is a Stack Template that deploys to existing EKS cluster essential pre-configured tools for ingress, DNS, TLS management, and monitoring.

The template deploys and configures:

- External DNS
- Cert Manager
- Traefik
- Prometheus
- Istio
- Harbor
- Postgresql

## Quick Start

### Prerequisites

- Mac OS or Linux, Docker
- EKS Cluster with `externalDNS` and `certManager` add-on policies enabled. The easiest way to provision the EKS cluster is using [eksctl](https://eksctl.io) tool. Example EKS cluster configuration is [here](eks.cluster.yaml)

### Steps to deploy Agile Stacks template

1. Download & Install the Automation Hub binary. Instructions are available here: [HUB CLI](https://docs.agilestacks.com/article/zrban5vpb5-install-toolbox). `cd` into template directory.
2. Run `toolbox` Docker image that contains all required tools for provisioning (AWS CLI, Terraform, kubectl, Helm, etc.): `hub toolbox`. You can deploy the stack without the `toolbox`, however in this case all required tools (with correct versions) must be installed on your workstation. Please refer to [Toolbox repo in GitHub](https://github.com/agilestacks/toolbox) to see what tools are required to deploy our stacks.
3. Before Stack Template can be deployed to your cluster you need to create an initial Agile Stacks Configuration. `hub ext platforms` command displays which of your Kubernetes clusters are already configured to work with Agile Stacks automation and which ones are not:

    ```console
    hub ext platforms

    List of Agile Stacks platform configurations:

    Kube context name                 ASI Platform name

    N/A Run hub configure -p <KUBE CONTEXT NAME> to add

    -----

    List of Kubernetes cluster contexts (from your local Kubeconfig) without Agile Stacks platform configuration:

    user@dev-cluster.eu-north-1.eksctl.io
    user@foo-cluster.eu-north-1.eksctl.io
    ```

4. Run `hub configure -p <kube context name>` to create Agile Stacks configuration for the given cluster. It is required to deploy a stack template using `hub ext deploy` Example:

    ```console
    hub configure -p user@dev-cluster.eu-north-1.eksctl.io

    Initial configuration for Kubernetes cluster user@dev-cluster.eu-north-1.eksctl.io has been created

    Agile Stacks platform name:   dusty-irving-44.dev.superhub.io
    Configuration file location:  /Users/oginskis/demo/devops-platfrom-eks-template/.hub/env/dusty-irving-44.dev.superhub.io.env
    Please review the configuration file of the platform and change settings such as AWS profile or Region if necessary!

    To apply environment for dusty-irving-44.dev.superhub.io run the following:
    source .env
    ```

    NOTE: `dusty-irving-44.dev.superhub.io` is a randomly generated name of your Agile Stacks platform. In the meantime, it will become a top-level domain for all the components (from the stack template) that require DNS (such as Traefik, Prometheus, etc.)

5. Run `hub ext deploy` to deploy the stack template
6. Run `hub ext undeploy` to undeploy the stack template

### Usefule features

If you want to switch to another Agile Stacks configuration run `hub configure -p <Agile Stacks configuration name>`

To delete existing configuration run `hub configure -p <Agile Stacks configuration name> -d`
