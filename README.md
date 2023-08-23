# terraform-infra-gcp

```bash
terraform-infra-gcp
├── key
│   ├── admin-somaz-service-project-dev.json
│   ├── admin-somaz-service-project-qa.json
│   ├── admin-somaz-service-project-prod.json
│   ├── admin-somaz-host-project.json
│   ├── somaz-bastion.pub
│   ├── somaz-gcs-cloudfront.json
│   ├── somaz-nfs-server.pub
│   ├── somaz-gitlab-server.pub
│   └── somaz-service-server.pub
├── modules
│   ├── cloud_armor
│   ├── gcs_buckets
│   ├── gke_autopilot
│   ├── memorystore
│   ├── mysql
│   ├── network
│   │   ├── modules
│   │   │   ├── fabric-net-firewall
│   │   │   ├── fabric-net-svpc-access
│   │   │   ├── firewall-rules
│   │   │   ├── network-firewall-policy
│   │   │   ├── private-service-connect
│   │   │   ├── routes
│   │   │   ├── routes-beta
│   │   │   ├── subnets
│   │   │   ├── subnets-beta
│   │   │   ├── vpc
│   │   │   └── vpc-serverless-connector-beta
│   ├── network_peering
│   ├── private_service_access
│   ├── secret_manager
│   ├── service_accounts
│   └── workload_identity_federation
└── project
    ├── somaz-service-project
    │   ├── dev
    │   ├── prod
    │   └── qa
    └── somaz-host-project
```

## Architecture
![architecture](https://github.com/somaz94/terraform-infra-gcp/assets/112675579/a7b5b1b8-82b9-4dff-b031-b7f0f5c8d2b2)

## Reference(Module)
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
