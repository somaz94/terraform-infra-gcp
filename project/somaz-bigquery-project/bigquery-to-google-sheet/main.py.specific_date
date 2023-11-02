import os
import gspread
import datetime
from google.cloud import bigquery
from oauth2client.service_account import ServiceAccountCredentials
import logging
import pytz

MAX_ROWS_PER_BATCH = 1000

def bigquery_to_sheets(request, desired_date="2023-06-09"): # Modify Date(ex.2023-06-01, 2023-07-01 ....)
    try:
        logging.info("Starting bigquery_to_sheets function")

        # BigQuery setup
        client = bigquery.Client()
        dataset_id = os.environ.get('BIGQUERY_DATASET', 'somaz.mongodb_dataset') # <project>.<dataset_name>
        
        # Get list of tables in the dataset
        tables = list(client.list_tables(dataset_id))
        
        if not tables:
            logging.warning("No tables found in the dataset.")
            return "No tables found in the dataset.", 400

        # Connect to Google Sheets
        scopes = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
        creds = ServiceAccountCredentials.from_json_keyfile_name('bigquery.json', scopes)
        gc = gspread.authorize(creds)
        logging.info("Connected to Google Sheets")

        # Open Google Sheets document
        sh = gc.open_by_key('1xxxxxxxxxxxxxxxXvB_M...')     # Google Sheet ID

        # Date filter preparation
        if "-" in desired_date and len(desired_date.split("-")) == 3:  # YYYY-MM-DD format check
            # Fetch data for that specific date
            date_filter = f"DATE(PARSE_TIMESTAMP('%a %b %d %H:%M:%S UTC %Y', time)) = '{desired_date}'"
        else:
            logging.warning(f"Invalid desired_date format: {desired_date}. Should be in 'YYYY-MM-DD' format.")
            return f"Invalid desired_date format: {desired_date}. Should be in 'YYYY-MM-DD' format.", 400

        # Filter for the 'reason' column
        reason_filter = "(reason = '/login' OR reason = '/login/unity')"

        # Combine date and reason filters
        combined_filter = f"{date_filter} AND {reason_filter}"

        for table in tables:
            table_id = table.table_id
            database_name = table_id.split('-')[0]
            worksheet_title = f"{desired_date} {database_name}"

            # Calculate the total number of rows in the table for the desired date and reason
            total_rows_query = f"SELECT COUNT(*) FROM `{dataset_id}.{table_id}` WHERE {combined_filter}"
            total_rows = client.query(total_rows_query).result().to_dataframe().iloc[0, 0]

            num_batches = -(-total_rows // MAX_ROWS_PER_BATCH)

            try:
                worksheet = sh.worksheet(worksheet_title)
                worksheet.clear()
            except gspread.exceptions.WorksheetNotFound:
                worksheet = sh.add_worksheet(title=worksheet_title, rows=str(total_rows+1), cols="20")

            schema = [field.name for field in client.get_table(f"{dataset_id}.{table_id}").schema]
            worksheet.append_row(schema)

            for batch_num in range(num_batches):
                offset = batch_num * MAX_ROWS_PER_BATCH
                query = f"SELECT * FROM `{dataset_id}.{table_id}` WHERE {combined_filter} LIMIT {MAX_ROWS_PER_BATCH} OFFSET {offset}"
                rows = client.query(query).result()

                batch_data = []
                for row in rows:
                    row_data = []
                    for item in row.values():
                        if isinstance(item, datetime.datetime):
                            seoul_timezone = pytz.timezone('Asia/Seoul')
                            localized_timestamp = item.replace(tzinfo=pytz.utc).astimezone(seoul_timezone)
                            formatted_timestamp = localized_timestamp.strftime('%Y-%m-%d %H:%M:%S')
                            row_data.append(formatted_timestamp)
                        else:
                            row_data.append(item)
                    batch_data.append(row_data)

                worksheet.append_rows(batch_data)

        logging.info("Data synced to Google Sheets!")
        return "Data synced to Google Sheets!", 200

    except Exception as e:
        logging.error(f"Error occurred: {e}")
        raise e
