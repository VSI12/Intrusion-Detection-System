import os
import base64
from io import BytesIO
from collections import Counter

import joblib
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt

matplotlib.use('Agg')  # Use non-interactive backend


# Column names for the dataset
COL_NAMES = [
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

# Label mapping for predictions
LABEL_MAPPING = {
    0: 'apache2', 1: 'back', 2: 'buffer_overflow', 3: 'ftp_write', 4: 'guess_passwd',
    5: 'httptunnel', 6: 'imap', 7: 'ipsweep', 8: 'land', 9: 'loadmodule',
    10: 'mailbomb', 11: 'mscan', 12: 'multihop', 13: 'named', 14: 'neptune',
    15: 'nmap', 16: 'normal', 17: 'perl', 18: 'phf', 19: 'pod',
    20: 'portsweep', 21: 'processtable', 22: 'ps', 23: 'rootkit', 24: 'saint',
    25: 'satan', 26: 'sendmail', 27: 'smurf', 28: 'snmpgetattack', 29: 'snmpguess',
    30: 'spy', 31: 'sqlattack', 32: 'teardrop', 33: 'udpstorm', 34: 'warezclient',
    35: 'warezmaster', 36: 'worm', 37: 'xlock', 38: 'xsnoop', 39: 'xterm'
}

# Load pre-fitted encoders and scaler
BASE_DIR = os.path.dirname(os.path.abspath(__file__))  # path to backend/

# Load preprocessing artifacts
label_encoders = joblib.load(os.path.join(BASE_DIR, "preprocess", "label_encoder.joblib"))
onehot_encoder = joblib.load(os.path.join(BASE_DIR, "preprocess", "onehot_encoder.joblib"))
scaler = joblib.load(os.path.join(BASE_DIR, "preprocess", "scaler.joblib"))
columns_info = joblib.load(os.path.join(BASE_DIR, "preprocess", "columns_info.joblib"))

# Extract column information
categorical_columns = columns_info["categorical_columns"]
dummy_columns = columns_info["dummy_columns"]


def preprocess(file_path):
    """
    Preprocess the input CSV file for ML inference.

    Args:
        file_path: Path to the CSV file to preprocess

    Returns:
        Scaled feature array ready for model prediction
    """
    # Load dataset
    try:
        df = pd.read_csv(file_path, header=None, names=COL_NAMES)
        print("DataFrame loaded successfully.")
    except Exception as e:
        print(f"Error reading CSV: {str(e)}")
        raise

    # Extract categorical and numerical features
    df_categorical = df[categorical_columns]
    df_numeric = df.drop(columns=categorical_columns + ["label"])

    # Encode categorical features using the loaded OneHotEncoder
    df_categorical_enc = pd.DataFrame()
    for col_name in df_categorical.columns:
        # Map each category to its corresponding index
        category_mapping = {
            cat: idx for idx, cat in enumerate(
                onehot_encoder.categories_[categorical_columns.index(col_name)]
            )
        }
        # Map column values to indices, fill NaNs with 0
        df_categorical_enc[col_name] = (
            df_categorical[col_name].map(category_mapping).fillna(0).astype(int)
        )

    df_categorical_onehot = onehot_encoder.transform(df_categorical_enc)
    # Create a DataFrame for one-hot encoded features
    df_categorical_onehot_df = pd.DataFrame(
        df_categorical_onehot, columns=dummy_columns
    )

    try:
        # Combine numerical and one-hot encoded features
        df_combined = pd.concat(
            [df_numeric.reset_index(drop=True), df_categorical_onehot_df], axis=1
        )

        # Add missing columns and align column order
        for col in scaler.feature_names_in_:
            if col not in df_combined.columns:
                df_combined[col] = 0
        df_combined = df_combined[scaler.feature_names_in_]
    except KeyError as e:
        print(f"Error while combining features: Missing columns. {str(e)}")
        raise
    except Exception as e:
        print(f"Unexpected error while combining features: {str(e)}")
        raise

    # Scale features using the loaded StandardScaler
    X_scaled = scaler.transform(df_combined)

    return X_scaled


def _create_plot_buffer(fig):
    """
    Save matplotlib figure to a base64-encoded buffer.

    Args:
        fig: Matplotlib figure object (or use current figure if None)

    Returns:
        Base64-encoded string of the plot image
    """
    buffer = BytesIO()
    plt.savefig(buffer, format="png")
    buffer.seek(0)
    plt.close()

    # Encode the image to base64
    graph_base64 = base64.b64encode(buffer.getvalue()).decode("utf-8")
    buffer.close()

    return graph_base64


def _generate_summary_plot(normal_count, malicious_count):
    """
    Generate a bar plot summarizing normal vs malicious traffic.

    Args:
        normal_count: Count of normal traffic instances
        malicious_count: Count of malicious traffic instances

    Returns:
        Base64-encoded string of the plot image
    """
    categories = ["Normal", "Malicious"]
    counts = [normal_count, malicious_count]

    plt.figure()
    plt.bar(categories, counts, color=["green", "red"])
    plt.title("Traffic Summary")
    plt.xlabel("Traffic Type")
    plt.ylabel("Count")

    return _create_plot_buffer(None)


def _generate_detailed_plot(labels):
    """
    Generate a detailed bar plot of all prediction classes.

    Args:
        labels: List of predicted class labels

    Returns:
        Base64-encoded string of the plot image
    """
    # Count occurrences of each label
    unique, counts = np.unique(labels, return_counts=True)

    # Create the bar graph
    plt.figure(figsize=(10, 6))
    plt.bar(unique, counts, color='skyblue')
    plt.xlabel('Prediction Classes', fontsize=12)
    plt.ylabel('Number of Predictions', fontsize=12)
    plt.title('Prediction Results by Class', fontsize=14)
    plt.xticks(rotation=45, ha='right')  # Rotate labels for clarity
    plt.tight_layout()

    return _create_plot_buffer(None)


def model(processed_data):
    """
    Run ML inference on preprocessed data and generate visualizations.

    Args:
        processed_data: Preprocessed feature array

    Returns:
        Dictionary containing predictions and visualization graphs
    """
    # Load the trained model
    model_obj = joblib.load(os.path.join(BASE_DIR, "models", "Random Forest.joblib"))
    predictions = model_obj.predict(processed_data)

    # Map predictions to class labels
    labels = [LABEL_MAPPING.get(pred, f"Unknown ({pred})") for pred in predictions]

    # Count the occurrences of each label
    label_counts = Counter(labels)

    # Separate Normal traffic and aggregate Malicious traffic
    normal_count = label_counts.get("normal", 0)
    malicious_count = sum(
        count for label, count in label_counts.items() if label != "normal"
    )

    # Print the summary
    print(f"Normal Traffic: {normal_count}")
    print(f"Malicious Traffic (aggregated): {malicious_count}")

    # Generate visualizations
    detailed_graph = _generate_detailed_plot(labels)

    return {
        "predictions": {
            "normal": normal_count,
            "malicious": malicious_count
        },
        "graph": detailed_graph
    }
