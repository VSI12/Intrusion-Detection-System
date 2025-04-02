import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, allow_headers=["Content-Type"])

@app.route('/upload', methods=['POST'])
def upload_file():
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        # Save the file to /tmp
        upload_path = os.path.join('/tmp', file.filename)
        os.makedirs('/tmp', exist_ok=True)
        file.save(upload_path)
        print(f"File saved to: {upload_path}")

        return jsonify({"message": f"File {file.filename} saved to {upload_path}"}), 200

    except Exception as e:
        print(f"Error uploading file: {str(e)}")
        return jsonify({"error": f"Failed to upload file: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)