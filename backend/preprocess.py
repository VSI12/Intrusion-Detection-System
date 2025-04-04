import os
import io
import joblib
import sys
import numpy as np
import pandas as pd
import base64
import matplotlib.pyplot as plt
from collections import Counter

sys.stdout.flush()
# Column names for the dataset
col_names = [
    "duration", "protocol_type", "service", "flag", "src_bytes", "dst_bytes", "land", 
    "wrong_fragment", "urgent", "hot", "num_failed_logins", "logged_in", "num_compromised", 
    "root_shell", "su_attempted", "num_root", "num_file_creations", "num_shells", 
    "num_access_files", "num_outbound_cmds", "is_host_login", "is_guest_login", "count", 
    "srv_count", "serror_rate", "srv_serror_rate", "rerror_rate", "srv_rerror_rate", 
    "same_srv_rate", "diff_srv_rate", "srv_diff_host_rate", "dst_host_count", 
    "dst_host_srv_count", "dst_host_same_srv_rate", "dst_host_diff_srv_rate", 
    "dst_host_same_src_port_rate", "dst_host_srv_diff_host_rate", "dst_host_serror_rate", 
    "dst_host_srv_serror_rate", "dst_host_rerror_rate", "dst_host_srv_rerror_rate", "label"
]

# Load pre-fitted encoders and scaler
base_dir = os.path.dirname(os.path.abspath(__file__))  # path to backend/
joblib_path = os.path.join(base_dir, "preprocess", "label_encoder.joblib")

label_encoders = joblib.load(os.path.join(base_dir, "preprocess", "label_encoder.joblib"))  # Dictionary with LabelEncoders
onehot_encoder = joblib.load(os.path.join(base_dir, "preprocess", "onehot_encoder.joblib"))  # Pre-fitted OneHotEncoder
scaler = joblib.load(os.path.join(base_dir, "preprocess", "scaler.joblib"))  # Pre-fitted StandardScaler
columns_info = joblib.load(os.path.join(base_dir, "preprocess", "columns_info.joblib"))  # Column order from training

# Extract column information
categorical_columns = columns_info["categorical_columns"]
dummy_columns = columns_info["dummy_columns"]

def preprocess(file):
    # Load datasets
    try:
        df = pd.read_csv(file, header=None, names=col_names)
        print("DataFrame loaded successfully.",flush=True)
    except Exception as e:
        print(f"Error reading CSV: {str(e)}",flush=True)

    # Extract categorical and numerical features
    df_categorical = df[categorical_columns]
    df_numeric = df.drop(columns=categorical_columns + ["label"])

    # Encode categorical features using the loaded OneHotEncoder
    print('here',flush=True)
    df_categorical_enc = pd.DataFrame()
    for col_name in df_categorical.columns:
        # Map each category to its corresponding index
        category_mapping = {cat: idx for idx, cat in enumerate(
            onehot_encoder.categories_[categorical_columns.index(col_name)]
        )}
        # Map column values to indices, fill NaNs with 0 (or other defaults as appropriate)
        df_categorical_enc[col_name] = df_categorical[col_name].map(category_mapping).fillna(0).astype(int)

    df_categorical_onehot = onehot_encoder.transform(df_categorical_enc)
    # Create a DataFrame for one-hot encoded features
    df_categorical_onehot_df = pd.DataFrame(df_categorical_onehot, columns=dummy_columns)

    try:
        # Combine numerical and one-hot encoded features
        df_combined = pd.concat([df_numeric.reset_index(drop=True), df_categorical_onehot_df], axis=1)

        # Add missing columns and align column order
        for col in scaler.feature_names_in_:
            if col not in df_combined.columns:
                df_combined[col] = 0
        df_combined = df_combined[scaler.feature_names_in_]
    except KeyError as e:
        print(f"Error while combining features: Missing columns. {str(e)}",flush=True)
        
    except Exception as e:
        print(f"Unexpected error while combining features: {str(e)}",flush=True)
        

    # Scale features using the loaded StandardScaler
    X_scaled = scaler.transform(df_combined)
    
    return X_scaled

def model(file):
    model = joblib.load(os.path.join(base_dir, "models", "Random Forest.joblib"))
    predictions = model.predict(file)

     # Generate a DataFrame for better plotting (optional, based on output structure)
    results_df = pd.DataFrame(predictions, columns=["Prediction"])
    
    # Plot the results
    label_mapping = {0: 'apache2', 1: 'back', 2: 'buffer_overflow', 3: 'ftp_write', 4: 'guess_passwd', 5: 'httptunnel', 6: 'imap', 7: 'ipsweep', 8: 'land', 9: 'loadmodule', 10: 'mailbomb', 11: 'mscan', 12: 'multihop', 13: 'named', 14: 'neptune', 15: 'nmap', 16: 'normal', 17: 'perl', 18: 'phf', 19: 'pod', 20: 'portsweep', 21: 'processtable', 22: 'ps', 23: 'rootkit', 24: 'saint', 25: 'satan', 26: 'sendmail', 27: 'smurf', 28: 'snmpgetattack', 29: 'snmpguess', 30: 'spy', 31: 'sqlattack', 32: 'teardrop', 33: 'udpstorm', 34: 'warezclient', 35: 'warezmaster', 36: 'worm', 37: 'xlock', 38: 'xsnoop', 39: 'xterm'}
    
    # Map predictions to class labels
    
    labels = [label_mapping.get(pred, f"Unknown ({pred})") for pred in predictions]
    
    # Count the occurrences of each label
    label_counts = Counter(labels)

    # Separate Normal traffic and aggregate Malicious traffic
    normal_count = label_counts.get("normal", 0)
    malicious_count = sum(count for label, count in label_counts.items() if label != "Normal")

    # Print the summary
    print(f"Normal Traffic: {normal_count}")
    print(f"Malicious Traffic (aggregated): {malicious_count}")
    
    # Plot the summary
    categories = ["Normal", "Malicious"]
    counts = [normal_count, malicious_count]
    plt.bar(categories, counts, color=["green", "red"])
    plt.title("Traffic Summary")
    plt.xlabel("Traffic Type")
    plt.ylabel("Count")
    plt.show()
    # Save plot to a buffer
    buffer0 = io.BytesIO()
    plt.savefig(buffer0, format="png")
    buffer0.seek(0)
    plt.close()

    # Encode the image to base64
    graph_base641 = base64.b64encode(buffer0.getvalue()).decode("utf-8")
    buffer0.close()

    # Count occurrences of each label
    unique, counts = np.unique(labels, return_counts=True)
    
    # Create the bar graph
    plt.figure(figsize=(10, 6))
    plt.bar(unique, counts, color='skyblue')
    plt.xlabel('Prediction Classes', fontsize=12)
    plt.ylabel('Number of Predictions', fontsize=12)
    plt.title('Prediction Results by Class', fontsize=14)
    plt.xticks(rotation=45, ha='right')  # Rotate labels for clarity
    
    # Save plot to a buffer
    buffer = io.BytesIO()
    plt.savefig(buffer, format="png")
    buffer.seek(0)
    plt.close()

    # Encode the image to base64
    graph_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")
    buffer.close()
    
    return {
        "predictions": {
            "normal": normal_count,
            "malicious": malicious_count
            },
        "graph": graph_base64,
        "graph2": graph_base641
    }
