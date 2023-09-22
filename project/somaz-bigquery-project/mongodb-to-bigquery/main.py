import os
from googleapiclient.discovery import build
from oauth2client.client import GoogleCredentials
from flask import jsonify

def start_dataflow(request):
    # An HTTP request is a Flask Request object, which allows for analysis of the request data using its methods.
    # If you wish to accept data via a POST request or intend to use a different method, modify this section accordingly.
    
    # Retrieve the environment variables
    PROJECT_ID = os.environ.get('PROJECT_ID')
    REGION = os.environ.get('REGION')
    SHARED_VPC = os.environ.get('SHARED_VPC')
    SUBNET_SHARE = os.environ.get('SUBNET_SHARE')
    SERVICE_ACCOUNT_EMAIL = os.environ.get('SERVICE_ACCOUNT_EMAIL')

    # Initialize authentication for the Google Cloud SDK
    credentials = GoogleCredentials.get_application_default()

    # Instantiate an API client for the Dataflow service
    service = build('dataflow', 'v1b3', credentials=credentials)

    databases = ["dev1", "production"]  # Define a list of MongoDB databases

    responses = []

    for database in databases:
        # Configure the Dataflow job parameters
        # https://cloud.google.com/dataflow/docs/reference/rest/v1b3/projects.locations.flexTemplates/launch
        # https://cloud.google.com/dataflow/docs/guides/templates/provided/mongodb-to-bigquery?hl=ko#api
        job_parameters = {
            "launchParameter": {
                "jobName": f"{database}-to-bigquery-job",
                "parameters": {
                    "mongoDbUri": f"mongodb://mongo:somaz@44.44.44.444:27017", # mongodb://<id>:<pw>@<ip>:<port>
                    "database": database,
                    "collection": "mongologs",
                    "outputTableSpec": f"{PROJECT_ID}:mongodb_dataset.{database}-mongodb-internal-table",
                    "userOption": "FLATTEN"
                },
                "environment": {
                    "tempLocation": "gs://mongodb-cloud-function-storage/tmp",
                    "network": SHARED_VPC,
                    "subnetwork": f"regions/{REGION}/subnetworks/{SUBNET_SHARE}-mgmt-b",
                    "serviceAccountEmail": SERVICE_ACCOUNT_EMAIL
                },
                "containerSpecGcsPath": 'gs://dataflow-templates/2023-08-29-00_RC00/flex/MongoDB_to_BigQuery'
            }
        }

        # Handle potential errors during Dataflow job initiation
        try:
            # Launch the Dataflow job
            request = service.projects().locations().flexTemplates().launch(
                projectId=PROJECT_ID,
                location=REGION,
                body=job_parameters
            )
            response = request.execute()
            responses.append(response)

        except Exception as e:
            print(f"An error occurred while processing {database}: {e}")
            responses.append({"database": database, "error": str(e)})

    return jsonify(responses)
