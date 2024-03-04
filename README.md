# terraform-infra-gcp 🚀
This repository contains the configuration files and modules to set up and manage infrastructure on Google Cloud Platform (GCP) using Terraform.

<br/>

## Directory Structure
📁 **key** : Contains service account keys, public keys, and other authentication-related files.
- `*.json` : Service account keys for various projects and services.
- `*.pub` : Public SSH keys for various services.

📁 **modules**: Reusable Terraform modules.
- `cloud_armor, gcs_buckets, ...` : Various Terraform modules for creating and managing different GCP resources.

📁 **project** : Configuration files specific to projects.
- `somaz-service-project` : Infrastructure setup for the service project (dev, prod, and qa environments).
- `somaz-host-project` : Infrastructure setup for the host project.
- `somaz-bigquery-project` : Infrastructure setup for the bigquery project. (mongodb -> bigquery -> google sheet connection)
- `somaz-ai-project` : Infrastructure setup for the ai project. (GPU Server)

<br/><br/>

## 🪂 Architecture
![architecture](https://github.com/somaz94/terraform-infra-gcp/assets/112675579/96eda2fd-a2d2-4e8c-ba38-9e2bedfc696c)

<br/><br/>

## 📊 Bigquery Workflow
![bigquery_workflow](https://github.com/somaz94/terraform-infra-gcp/assets/112675579/ce735fcf-4ff5-4fed-a1c0-b23a88a3044e)

<br/><br/>

## 🌐 Reference

### Module
- [cloud_armor](https://github.com/GoogleCloudPlatform/terraform-google-cloud-armor)
- [gcs_buckets](https://github.com/terraform-google-modules/terraform-google-cloud-storage)
- [gke_autopilot](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/master/modules/beta-autopilot-public-cluster)
- [memorystore](https://github.com/terraform-google-modules/terraform-google-memorystore)
- [mysql](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/mysql)
- [network](https://github.com/terraform-google-modules/terraform-google-network)
- [network_peering](https://github.com/terraform-google-modules/terraform-google-network/tree/master/modules/network-peering)
- [private_service_access](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/private_service_access)
- [secret_manager](https://github.com/GoogleCloudPlatform/terraform-google-secret-manager)
- [service_accounts](https://github.com/terraform-google-modules/terraform-google-service-accounts)
- [workload_identity_federation](https://github.com/mscribellito/terraform-google-workload-identity-federation)

### README
- [somaz-ai-project](https://github.com/somaz94/terraform-infra-gcp/blob/main/project/somaz-ai-project/README.md)
- [somaz-bigquery-project](https://github.com/somaz94/terraform-infra-gcp/blob/main/project/somaz-bigquery-project/README.md)
- [terraform-bigquery-project](https://github.com/somaz94/terraform-bigquery-googlesheet)

<br/>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<br/>

## 👨‍👩‍👦‍👧 Contributing
Contributions to enhance and improve this repository are always welcome. Please follow the standard Git workflow:

1. Fork the repository.
2. Make your changes or additions.
3. Submit a pull request.
