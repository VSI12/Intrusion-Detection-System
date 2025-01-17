import boto3

from flask import Flask
from flask_cors import CORS
from botocore.exceptions import ClientError


app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "http://localhost:3000"}}, methods=["POST"])
@app.route('/')
def home():
    return "Welcome to the Intrusion Detection System!"

if __name__ == '__main__':
    app.run(debug=True)