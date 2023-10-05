# DNSimple Network Infrastructure Automation with Consul and Terraform Demo

Welcome to DNSimple's Network Infrastructure Automation with Consul and Terraform demo. This demo is designed to provide a structured environment for you to gain practical insights into infrastructure automation and service discovery. With a focus on real-world application, this demo guides you through a systematic process of setting up, deploying, and managing services in a simulated environment. By integrating DNSimple for domain management, Docker for containerization, and employing Consul for service discovery alongside Terraform for infrastructure as code, you'll experience the seamless interaction between these technologies. As you progress through the steps, from preparing configuration files to deploying and updating services, you'll grasp the essential concepts and practices that underpin modern network infrastructure automation. Whether you're looking to hone your skills or exploring new horizons in automation, this demo provides a comprehensive and engaging platform to enhance your understanding and capabilities in orchestrating network resources efficiently.

What you'll gain from this demo:

- Grasp the strategic advantage of Infrastructure as Code (IaC) through Consul and Terraform, enabling rapid, consistent and error-free provisioning of network resources which can significantly accelerate the time-to-market.
- Dive into the automated service deployment and DNS record updates enabled by Consul-Terraform Sync, illustrating a model for maintaining real-time service availability and domain resolution which are essential for business continuity.
- Practical insights into the seamless integration between DNSimple, Consul, and Terraform, providing a holistic view of the network infrastructure automation process.

## Prerequisites

- A zone on DNSimple (e.g. `example.com`) - whether it's registered with DNSimple or not. It doesn't need to be managed by DNSimple's name servers, but you won't be able to see the changes live. Only using DNSimple's UI. Don't have an account? [Sign up free](https://dnsimple.com/sign_up).
  - If you'd like to register and set up a domain entirely through Terraform, check out our [domains demo](../domains).
- API access token with write access to the zone. Create a new token by [following our support article](https://support.dnsimple.com/articles/api-access-token/). Note the token and your account ID, as you will need them later.
- Docker and Docker Compose installed on your machine. [Install Docker](https://docs.docker.com/get-docker/).

## Getting Started

### Step 1: Prepare the configuration files

Copy the `terraform.tfvars.example` file to `terraform.tfvars` and fill in the required variables.

```bash
cp config/terraform.tfvars.example config/terraform.tfvars
cp config/api-service.json.example config/api-service.json
cp config/web-service.json.example config/web-service.json
```

Next you would need to update the `api-service.json` and `web-service.json` files with the zone which you have chosen to use for this demo. You can also take this chance to inspect the configuration of the services and familiarize yourself with the syntax and options available.

### Step 2: Create the infrastructure

In this demo, we will be using Docker Compose to create the infrastructure. This will create a Consul server and two Consul clients. The Consul clients will be running the `api-service` and `web-service` containers. In addition we will also be running the consul-terraform-sync container which will be responsible for syncing the Consul service catalog with the Terraform state.

```bash
docker compose up -d
```

The following ports will be exposed on the host machine:

| Port | Protocol | Description           |
| ---- | -------- | --------------------- |
| 8500 | TCP      | Consul Server         |
| 8600 | TCP      | Consul Server         |
| 8600 | UDP      | Consul Server         |
| 8501 | TCP      | Consul Client B       |
| 8558 | TCP      | Consul Terraform Sync |

If any of these ports are already in use on your machine you can change the port mapping in the `docker-compose.yml` file.

### Step 3: Verify the infrastructure

Once the containers are up and running you can verify that the Consul server and clients are running by running the following command:

```bash
docker compose ps --format "table {{.Name}}\t{{.State}}\t{{.Ports}}"
```

You should see output similar to the following:

```bash
Name              State     Ports
--------------------------------------------------------------------------------
consul-client-a   running   8300-8302/tcp, 8500/tcp, 8301-8302/udp, 8600/tcp, 8600/udp
consul-client-b   running   8300-8302/tcp, 8301-8302/udp, 8600/tcp, 8600/udp, 0.0.0.0:8501->8500/tcp
```

You can also visit the Consul UI at http://localhost:8500/ui and verify that the services have been registered.

### Step 4: Deploy the services

Now that the infrastructure is up and running we can deploy the services. To do this we will be using a helper script in `bin/servicesctl` which provides a utility wrapper around the Consul HTTP API making interactions simpler. The script will read the service definitions from the `api-service.json` and `web-service.json` files and register them with Consul.

```bash
./bin/servicesctl deploy
```

You can verify that the services have been registered by visiting the Consul UI at http://localhost:8500/ui and clicking on the `Services` tab.

### Step 5: Verify the DNS records are created

Once the services have been registered you can verify that the DNS records have been created by the CTS container. You should be able to see the logs from the CTS container by running the following command:

```bash
docker logs cts
```

You should also be able to see the changes at DNSimple. If you had used a production account with a real domain you would be able to verify the changes by running the following command:

```bash
dig @ns1.dnsimple.com api.example.com
```

### Step 6: Update the services

Now that the services have been deployed we can update the service definitions and see how the CTS container reacts to the changes. To do this we will be updating the `api-service.json` and `web-service.json` files and changing the `port` value to a value of your choice. Once you have updated the files you can run the following command to update the services:

```bash
./bin/servicesctl deploy
```

You should be able to see the changes in the logs from the CTS container as well as at DNSimple. If you had used a production account with a real domain you would be able to verify the changes through a DNS lookup via something like `dig`.

### Step 7: Cleanup

Once you are done with the demo you can cleanup the changes by running the following command:

```bash
./bin/servicesctl teardown
```

This will remove the services from Consul and also remove the DNS records from DNSimple as the CTS container reacts to the changes.

Next you can stop the containers by running the following command:

```bash
docker compose down
```

### Troubleshooting

- If you are having issues with the CTS container not applying the changes and you do not see any errors in the logs you can change the log level to `DEBUG` in the `config/cts-config.hcl` file and restart the container. This will provide more verbose logging which should help you debug the issue. To restart the container you can run the following command:

```bash
docker compose down
docker compose up -d
```

## Taking it further

Most often you would see Consul being used as part of the HashiStack which includes Vault and Nomad. You can take this demo further by adding Nomad to the mix and seeing how the CTS container reacts to changes in the Nomad jobs.

## What's next?

- Improve security and compliance by using HashiCorp Sentinel to enforce policy-as-code with the [DNSimple Terraform Sentinel Demo](../sentinel)
- Manage DNS records with Terraform using the [DNSimple DNS Records Demo](../dns-change-management)
- Register and manage domains with Terraform using the [DNSimple Domains Demo](../domains)
- End-to-end example of using Terraform to provision TLS certificates with DNSimple's Let's Encrypt endpoint using the [DNSimple Terraform TLS Demo](../tls-web-application)
