# Agile Stacks [DevOps] platform on EKS

**Agile Stacks DevOps platform on EKS** is a Stack Template that deploys to an existing EKS cluster essential pre-configured tools for **ingress**, **DNS**, and **TLS** management and eliminates the need to configure all the required tools manually.

Additionally, we deploy a free randomly generated public platform DNS name in `devops.delivery` zone (example: `fluffy-dog-12.devops.delivery`), that enables platform users to access their services from the internet.

The template deploys and configures:

* [**External DNS**](https://github.com/kubernetes-sigs/external-dns)
    <!-- markdownlint-disable MD033 -->
    <img src="external-dns.png" width="100">

    *ExternalDNS synchronizes exposed Kubernetes Services and Ingresses with DNS providers.*
* [**Cert Manager**](https://github.com/jetstack/cert-manager)

    <img src="cert-manager.png" width="100">

    *cert-manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.*
* [**Traefik**](https://containo.us/traefik/)

    <img src="traefik.logo.png" width="100">

    *Traefik is the leading open source reverse proxy and load balancer for HTTP and TCP-based applications that is easy, dynamic, automatic, fast, full-featured, production proven, provides metrics, and integrates with every major cluster technology.*

## Getting Started

### Prerequisites

* Mac OS or Linux, Docker
* EKS Cluster with `externalDNS` and `certManager` add-on policies enabled. The easiest way to provision the EKS cluster is using [eksctl](https://eksctl.io) tool. Example EKS cluster configuration is [here](eks.cluster.yaml)

### Steps to deploy Agile Stacks DevOps platform on EKS Stack Template

1. Download & Install the Automation Hub CLI binary. Instructions are available here: [HUB CLI](https://docs.agilestacks.com/article/zrban5vpb5-install-toolbox). `git clone` and `cd` into the template directory. Install Hub CLI extensions using `hub extensions install`
2. Run `toolbox` Docker image that contains all required tools for provisioning (AWS CLI, Terraform, kubectl, Helm, etc.): `hub toolbox`.

    *NOTE: You can deploy the stack without the `toolbox`, however in this case all required tools (with correct versions) must be installed on your workstation. Please refer to [Toolbox repo in GitHub](https://github.com/agilestacks/toolbox) to see what tools are required to deploy our stacks.*

3. Before Stack Template can be deployed to your cluster you need to create an initial Agile Stacks Configuration. `hub ls` command displays which of your Kubernetes clusters are already configured to work with Agile Stacks automation and which ones (from your local Kubeconfig) are not:

    ```console
    hub ls

    List of Agile Stacks platform configurations:

    Kube context name          ASI Platform configuration name

    N/A Run hub configure -p <KUBE CONTEXT NAME> to add

    -----

    List of Kubernetes cluster contexts (from your local Kubeconfig) without Agile Stacks platform configuration:

    user@dev.eu-north-1.eksctl.io
    user@qa.eu-north-1.eksctl.io
    ```

4. Run `hub configure -p <kube context name>` to create Agile Stacks configuration for the given cluster. (*It is required to later deploy a stack template using `hub ext deploy`*) .Example:

    ```console
    hub configure -p user@dev.eu-north-1.eksctl.io

    Initial configuration for Kubernetes cluster user@dev.eu-north-1.eksctl.io has been created

    Agile Stacks platform name:   waiting-moose-859.devops.delivery
    Configuration file location:  /Users/foo/template/.hub/env/waiting-moose-859.devops.delivery.env

    To apply the environment for waiting-moose-859.devops.delivery run the following:
    source .env

    ```

    *NOTE: `waiting-moose-859.devops.delivery` is a randomly generated name of your Agile Stacks platform. In the meantime, it will become a top-level domain for all the components (from the stack template) that require DNS (such as Traefik, etc.)*

5. Run `hub ext deploy` to deploy the stack template (with External DNS, Cert Manager, and Traefik). The components will be deployed in the order specified in [hub.yaml](hub.yaml) file. Parameters of the stack (such as DNS prefix for Traefik, etc.) are in [params.yaml](params.yaml) file.

    *More information about Agile Stacks Superhub deployment manifests, lifecycle and parameters are available [here](https://docs.agilestacks.com/article/zncz3d0zmb-manifest)*

    **NOTE: The template deploys fast, however it takes time for the components to provision DNS records and issue TLS certificates.**

6. Once stack is deployed, stack parameters and outputs can be discovered using `hub show -s <platform name> -c <component name>` command. Example, show outputs of `Traefik` component (`jq '.outputs'` filters out outputs only):

    ```console
    hub show -s waiting-moose-859.devops.delivery -c traefik | jq '.outputs'
    {
    "component.ingress.dashboard.url": "https://apps.waiting-moose-859.devops.delivery/dashboard/",
    "component.ingress.fqdn": "app.waiting-moose-859.devops.delivery",
    "component.ingress.kubernetes.ingressClass": "",
    "component.ingress.loadBalancer": "a7affa639a0a84f389c300e94ac10946-2058104707.eu-north-1.elb.amazonaws.com",
    "component.ingress.loadBalancerDnsRecordType": "CNAME",
    "component.ingress.protocol": "https",
    "component.ingress.ssoFqdn": "apps.waiting-moose-859.devops.delivery",
    "component.ingress.ssoUrlPrefix": "apps",
    "component.ingress.urlPrefix": "app"
    }
    ```

    Using the `hub show` command above we discovered that URL of the Traefik dashboard is `https://apps.waiting-moose-859.devops.delivery/dashboard/`

7. Run `hub ext undeploy` to undeploy the stack template

### Useful features

If you want to switch to another Agile Stacks configuration (and work with another EKS cluster) run `hub configure -p <Agile Stacks configuration name>`

To delete existing configuration run `hub configure -p <Agile Stacks configuration name> -d`
