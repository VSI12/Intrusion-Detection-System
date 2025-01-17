import joblib
import pandas as pd
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, StandardScaler

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
label_encoders = joblib.load("backend\python\preprocess\label_encoder.joblib")  # Dictionary with LabelEncoders
onehot_encoder = joblib.load("backend\python\preprocess\onehot_encoder.joblib")  # Pre-fitted OneHotEncoder
scaler = joblib.load("backend\python\preprocess\scaler.joblib")  # Pre-fitted StandardScaler
columns_info = joblib.load("backend\python\preprocess\columns_info.joblib")  # Column order from training

# Extract column information
categorical_columns = columns_info["categorical_columns"]
dummy_columns = columns_info["dummy_columns"]

def preprocess(file):
    # Load datasets
    df = pd.read_csv(file,header=None, names = col_names)

    # Extract categorical and numerical features
    df_categorical = df[categorical_columns]
    df_numeric = df.drop(columns=categorical_columns + ["label"])

    # Encode categorical features using the loaded OneHotEncoder
    df_categorical_enc = df_categorical.apply(
        lambda col: onehot_encoder.categories_[categorical_columns.index(col.name)].tolist().index(col)
    )
    df_categorical_onehot = onehot_encoder.transform(df_categorical_enc)

    # Create a DataFrame for one-hot encoded features
    df_categorical_onehot_df = pd.DataFrame(df_categorical_onehot, columns=dummy_columns)

    # Combine numerical and one-hot encoded features
    df_combined = pd.concat([df_numeric, df_categorical_onehot_df], axis=1)

    # Add missing columns (if any) with default values and align column order
    for col in dummy_columns:
        if col not in df_combined.columns:
            df_combined[col] = 0
    df_combined = df_combined[dummy_columns]

    # Scale features using the loaded StandardScaler
    X_scaled = scaler.transform(df_combined)
    
    return X_scaled
