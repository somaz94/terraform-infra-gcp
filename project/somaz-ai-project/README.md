# Setting Up NVIDIA A100 GPUs on Google Cloud Platform

<br/>

## Requesting GPU Quotas on GCP
Before using GPUs on the Google Cloud Platform, you must request quotas for the necessary resources. Below are examples of quota requests for NVIDIA A100 GPUs.

- **a2-highgpu-2g:** 2 x [NVIDIA A100 40GB GPUs](https://www.nvidia.com/en-us/data-center/a100/)
- **a2-ultragpu-2g:** 2 x [NVIDIA A100 80GB GPUs](https://www.nvidia.com/en-us/data-center/a100/)

<br/>

## Configuring Service and API Service Accounts for Shared VPC Use
When working with a shared VPC on Google Cloud Platform, it's crucial to configure the appropriate service accounts to ensure your project's components have the necessary access and permissions. Below is a step-by-step guide to setting up and assigning roles to your Google API service account, tailored for projects utilizing a shared VPC.

### 1. Identify the Google API Service Account:
Begin by identifying the Google API service account associated with your project. This account is essential for managing access and permissions across GCP services. Use the following command to retrieve the service account details, replacing [PROJECT_ID] with your actual project ID.
```bash
GCP_API_SA=$(gcloud projects describe [PROJECT_ID] --format 'value(projectNumber)')@cloudservices.gserviceaccount.com
echo $GCP_API_SA
```
- This command outputs the service account identifier, which you will use in subsequent steps.

### 2.Assign Necessary Roles:
With the service account identifier at hand, proceed to assign the roles required for operating within a shared VPC context. These roles enable the service account to interact with container services, manage network configurations, and view compute resources. Execute the following commands, ensuring to replace [PROJECT_ID] with your project ID:
```bash
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:$GCP_API_SA --role roles/container.serviceAgent
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:$GCP_API_SA --role roles/compute.networkUser
gcloud projects add-iam-policy-binding [PROJECT_ID] --member serviceAccount:$GCP_API_SA --role roles/compute.viewer
```
- These commands grant the Google API service account the necessary permissions to function effectively within the shared VPC environment.

By following these steps, you ensure that your project's service accounts are correctly set up and have the appropriate permissions for shared VPC use. This setup is critical for maintaining security and access control in your GCP environment, enabling seamless interaction with Google Cloud services.

<br/>

## Checking Resource Availability
Verify the availability of GPU resources:
```bash
gcloud compute accelerator-types list --filter="name:nvidia-tesla-a100 AND zone:[ZONE]" # 2 x [NVIDIA A100 40GB GPUs]
gcloud compute accelerator-types list --filter="nvidia-a100-80gb AND zone:[ZONE]" # 2 x [NVIDIA A100 80GB GPUs]
```

<br/>

## Summary for README
The above instructions provide a basic guide for configuring NVIDIA A100 GPU resources on GCP, and quota requests. Adjust the content based on the specific requirements of your project, ensuring users can easily understand and follow each step. Include clear information for each phase, relevant links, and any additional explanations to facilitate a seamless setup process.