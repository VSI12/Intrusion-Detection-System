import os
import boto3

from flask import Flask
from flask_cors import CORS
from dotenv import load_dotenv
from botocore.exceptions import ClientError


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:3000"}}, methods=["POST"])

# Fetch environment variables
load_dotenv()  
AWS_REGION = os.getenv("AWS_REGION")
S3_BUCKET = os.getenv("S3_BUCKET_NAME")

@app.route('/')
def home():
    return "Welcome to the Intrusion Detection System!"

if __name__ == '__main__':
    app.run(debug=True)