# 🧠 Flask Backend – Intrusion Detection System API

This is the backend service for the Intrusion Detection System (IDS) project, built with **Flask**. It provides a REST API for uploading network traffic files, preprocessing the data, running inference with a machine learning model, and returning the classification results.

---

## 🚀 Features

- Accepts CSV file uploads for intrusion detection
- Preprocesses input using trained encoders and scalers
- Runs inference using a pre-trained model
- Returns predictions with charts encoded in base64
- CORS configured for integration with frontend
- Containerized for deployment on AWS ECS Fargate
- Integrated into a multi-environment CI/CD pipeline

---

## 📦 Project Structure
```
├── app.py # Main Flask API
├── preprocess.py # Data preprocessing and inference logic 
├── requirements.txt # Python dependencies 
├── Dockerfile # Container build config 
├── model/ 
│ ├── model.joblib # Trained ML model 
├── preprocess/ 
│ ├── encoders/ # Scaler and encoder files
├── NSL_KDD/ 
│ ├── NSL_KDD_Test.csv #Testing Dataset
│ └── NSL_KDD_Train.csv #Training Dataset
```

---

## ⚙️ Running Locally

> Make sure you have Python 3.9+ and `pip` installed.

```bash
# Create a virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py

