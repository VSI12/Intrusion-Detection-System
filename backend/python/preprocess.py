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
one_hot_encoder = joblib.load("backend\python\preprocess\onehot_encoder.joblib")  # Pre-fitted OneHotEncoder
scaler = joblib.load("backend\python\preprocess\scaler.joblib")  # Pre-fitted StandardScaler
columns_info = joblib.load("backend\python\preprocess\columns_info.joblib")  # Column order from training


def preprocess(file):
    # Load datasets
    df = pd.read_csv(file,header=None, names = col_names)
