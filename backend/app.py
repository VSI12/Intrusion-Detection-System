import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
from preprocess import preprocess, model

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, allow_headers=["Content-Type"])


@app.route("/health")
def health():
    return "OK", 200

@app.route('/upload', methods=['POST'])
def upload_file(): 
    try:
        if 'file' not in request.files:
            return jsonify({"error": "No file part"}), 400
        
        file = request.files['file']
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
        
        # Save the file to /tmp dir within fargate
        upload_path = os.path.join('/tmp', file.filename)
        os.makedirs('/tmp', exist_ok=True)
        file.save(upload_path)
        print(f"File saved to: {upload_path}")

         # Step 1: Preprocess the file
        processed_data = preprocess(upload_path)
        print("Data preprocessed successfully.")
        # Step 2: Run ML inference
        predictions = model(processed_data)

        return jsonify({
            "message": f"File {file.filename} processed successfully.",
            "predictions": predictions["predictions"],
            "graph": predictions["graph"]
        }), 200

    except Exception as e:
        print(f"Error: {str(e)}")
        return jsonify({"error": f"Failed to process file: {str(e)}"}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))