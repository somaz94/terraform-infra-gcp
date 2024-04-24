import base64
import json
import requests

def process_log(event, context):
    """Triggered by a Pub/Sub message.
    Args:
        event (dict): Event payload.
        context (google.cloud.functions.Context): Metadata for the event.
    """
    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    log_entry = json.loads(pubsub_message)
    
    print(f"Received log entry: {log_entry}")

    # Convert log data to a suitable metric format if necessary
    # Here we assume log_entry contains the metric name and value
    metric_name = log_entry.get('metric_name', 'default_metric')
    metric_value = log_entry.get('metric_value', 0)
    pushgateway_url = 'http://your-pushgateway-url:9091/metrics/job/some_job'

    # Push the metric to the Pushgateway
    response = requests.post(pushgateway_url, data=f"{metric_name} {metric_value}\n")
    print(f"Data posted to Pushgateway: {response.status_code}")
