import os
import json
import boto3

from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from botocore.exceptions import ClientError


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:3000"}}, methods=["GET", "POST", "OPTIONS"])

# Fetch environment variables
load_dotenv()  
AWS_REGION = os.getenv("AWS_REGION")
S3_BUCKET = os.getenv("S3_BUCKET_NAME")
SQS_QUEUE_URL = os.getenv("SQS_URL")

# Initialize the S3 and SQS client
s3_client = boto3.client("s3", region_name=AWS_REGION)
sqs_client = boto3.client("sqs", region_name=AWS_REGION)

@app.route('/generate-presigned-url', methods=['POST'])
def generate_presigned_url():
    try:
        data = request.json
        file_name = data.get("file_name")
        file_type = data.get("file_type")
        
        if not file_name or not file_type:
            return jsonify({"error": "Missing file_name or file_type"}), 400
        
        # Generate the presigned URL for PUT
        presigned_url = s3_client.generate_presigned_url(
            'put_object',
            Params={
                'Bucket': S3_BUCKET,
                'Key': file_name,
                'ContentType': file_type
            },
            ExpiresIn=3600  # URL expires in 1 hour
        )
        return jsonify({"url": presigned_url})
    except ClientError as e:
        print(f"Error generating presigned URL: {str(e)}")
        return jsonify({"error": "Failed to generate presigned URL"}), 500

def receive_and_process_sqs_message():
    """
    Receives a message from the SQS queue, processes it, and downloads the associated S3 file.
    Returns the local file path or None if an error occurs.
    """
    try:
        response = sqs_client.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=10
        )
        messages = response.get("Messages", [])
        if not messages:
            return None, "No messages in the queue"

        # Parse SQS message
        sqs_message = messages[0]
        receipt_handle = sqs_message["ReceiptHandle"]
        message_body = json.loads(sqs_message["Body"])
        records = message_body.get("Records", [])

        if not records:
            return None, "No S3 event records found in the message"

        # Extract S3 bucket and object key
        s3_record = records[0]["s3"]
        bucket_name = s3_record["bucket"]["name"]
        object_key = s3_record["object"]["key"]
        local_path = f"{object_key}"
# Download file from S3
        s3_client.download_file(bucket_name, object_key, local_path)
        print(f"File downloaded to: {local_path}")

        # Delete the SQS message
        sqs_client.delete_message(QueueUrl=SQS_QUEUE_URL, ReceiptHandle=receipt_handle)
        print("Message deleted from queue")
        return local_path
    except KeyError as e:
        return None, f"KeyError in SQS message: {e}"
    except json.JSONDecodeError as e:
        return None, f"Error decoding JSON: {e}"
    except ClientError as e:
        return None, f"AWS ClientError: {e}"
    except Exception as e:
        return None, f"Unexpected error: {e}"
    
@app.route('/process', methods=['POST'])
def process_model():
    """Processes the uploaded dataset by receiving it from SQS and performing analysis."""
    from preprocess import preprocess, model

    try:
        # Process the SQS message to get the sfile path
        local_path = receive_and_process_sqs_message()
        print(local_path)
        if not local_path:
            print("Error: Failed to process SQS message or download file.")
            return jsonify({"error": "Failed to process SQS message or download file"}), 400
        
        # Preprocess the downloaded file
        try:
            processed_data = preprocess(local_path)
        except Exception as e:
            print(f"Error during preprocessing: {str(e)}")
            return jsonify({"error": "Preprocessing failed"}), 500

        # Run the model on the preprocessed data
        try:
            # Simulate intrusion detection by passing X_test_inference to the trained model
            predictions = model(processed_data)

            return jsonify({
            "message": "Processing complete",
            "predictions": predictions["predictions"],
            "graph": predictions["graph"]
        }), 200

        except Exception as e:
            print(f"Error processing model: {str(e)}")
            return jsonify({"error": "Failed to process model"}), 500

    except Exception as e:
        print(f"Unexpected error in /process route: {str(e)}")
        return jsonify({"error": "An unexpected error occurred"}), 500
    
if __name__ == '__main__':
    app.run(debug=True)