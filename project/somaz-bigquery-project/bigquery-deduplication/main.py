import os
from google.cloud import bigquery

def remove_duplicates(request):
    # Initialize the BigQuery client
    client = bigquery.Client()

    # Fetch the project ID from environment variables
    PROJECT_ID = os.environ.get('PROJECT_ID')

    # Define the database to use
    database = "production" 

    # Construct the SQL query with deduplication logic
    query = f"""
    DELETE
    FROM `{PROJECT_ID}.mongodb_dataset.{database}-mongodb-internal-table`
    WHERE STRUCT(_id, timestamp) NOT IN (
      SELECT AS STRUCT _id, MAX(timestamp) as timestamp
      FROM `{PROJECT_ID}.mongodb_dataset.{database}-mongodb-internal-table`
      GROUP BY _id
    )
    """

    # Execute the query on BigQuery
    query_job = client.query(query)

    # Wait for the query to complete
    query_job.result()

    # Return a confirmation message once deduplication is complete
    return 'Duplicates have been removed.'
