# terraform-infra-gcp 🚀
This repository contains the configuration files and modules to set up and manage infrastructure on Google Cloud Platform (GCP) using Terraform.

## ⛄ Directory Structure 
📁 key: Contains service account keys, public keys, and other authentication-related files.
- *.json: Service account keys for various projects and services.
- *.pub: Public SSH keys for various services.

📁 modules: Reusable Terraform modules.
- cloud_armor, gcs_buckets, ... : Various Terraform modules for creating and managing different GCP resources.

📁 project: Configuration files specific to projects.
- somaz-service-project: Infrastructure setup for the service project (dev, prod, and qa environments).
- somaz-host-project: Infrastructure setup for the host project.

## 🪂 Architecture
![architecture](https://github.com/somaz94/terraform-infra-gcp/assets/112675579/a7b5b1b8-82b9-4dff-b031-b7f0f5c8d2b2)

## 🌐 Reference(Module)
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

## Contributing
Contributions to enhance and improve this repository are always welcome. Please follow the standard Git workflow:

1. Fork the repository.
2. Make your changes or additions.
3. Submit a pull request.
