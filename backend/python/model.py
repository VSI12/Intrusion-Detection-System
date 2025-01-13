# Import necessary libraries
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder, OneHotEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score, precision_score, recall_score, f1_score
import joblib
import seaborn as sns
import matplotlib.pyplot as plt
from joblib import dump
import os

# File paths
train_url = "backend/python/NSL-KDD-Dataset/NSL_KDD_Train.csv"
test_url = "backend/python/NSL-KDD-Dataset/NSL_KDD_Test.csv"

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

# Load datasets
df = pd.read_csv(train_url,header=None, names = col_names)
df_test = pd.read_csv(test_url, header=None, names = col_names)

# Extract categorical columns
categorical_columns = ["protocol_type", "service", "flag"]
df_categorical_values = df[categorical_columns]
testdf_categorical_values = df_test[categorical_columns]

# Encode categorical columns
df_categorical_values_enc = df_categorical_values.apply(LabelEncoder().fit_transform)
testdf_categorical_values_enc = testdf_categorical_values.apply(LabelEncoder().fit_transform)

# One-hot encoding for categorical features
enc = OneHotEncoder(categories='auto', sparse_output=False)
df_categorical_values_encenc = enc.fit_transform(df_categorical_values_enc)
testdf_categorical_values_encenc = enc.transform(testdf_categorical_values_enc)

# Convert to DataFrame
dumcols = (
    [f"protocol_type_{cat}" for cat in sorted(df.protocol_type.unique())] +
    [f"service_{cat}" for cat in sorted(df.service.unique())] +
    [f"flag_{cat}" for cat in sorted(df.flag.unique())]
)
df_cat_data = pd.DataFrame(df_categorical_values_encenc, columns=dumcols)
testdf_cat_data = pd.DataFrame(testdf_categorical_values_encenc, columns=dumcols)

# Drop original categorical columns and merge with encoded data
df_numeric = df.drop(columns=categorical_columns)
df_test_numeric = df_test.drop(columns=categorical_columns)
df_preprocessed = pd.concat([df_numeric, df_cat_data], axis=1)
df_test_preprocessed = pd.concat([df_test_numeric, testdf_cat_data], axis=1)

# Split features and labels
X_train = df_preprocessed.drop(columns=["label"])
y_train = df_preprocessed["label"]

X_test = df_test_preprocessed.drop(columns=["label"])
y_test = df_test_preprocessed["label"]

# Encode labels
# Combine y_train and y_test to include all labels in the encoder
combined_labels = pd.concat([y_train, y_test], axis=0)

# Fit the LabelEncoder on the combined labels
label_encoder = LabelEncoder()
label_encoder.fit(combined_labels)

# Transform y_train and y_test
y_train_enc = label_encoder.transform(y_train)
y_test_enc = label_encoder.transform(y_test)
# Feature scaling
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# # Train a Random Forest Classifier
# model = RandomForestClassifier(n_estimators=100, random_state=42)
# model.fit(X_train_scaled, y_train_enc)

# # Save the trained model
# joblib.dump(model, "random_forest_model.joblib")
# print("Model saved as 'random_forest_model.joblib'")

# # Predict on test set
# y_pred = model.predict(X_test_scaled)

# # Confusion matrix and classification report
# cm = confusion_matrix(y_test_enc, y_pred)
# # Filter target names to match actual classes in y_test_enc
# actual_classes = np.unique(y_test_enc)
# filtered_target_names = [label_encoder.classes_[i] for i in actual_classes]

# # Generate the classification report
# report = classification_report(y_test_enc, y_pred, target_names=filtered_target_names)

# print("\nClassification Report:")
# print(report)

# # Plot confusion matrix
# plt.figure(figsize=(10, 8))
# sns.heatmap(cm, annot=True, fmt="d", cmap="Blues", xticklabels=label_encoder.classes_, yticklabels=label_encoder.classes_)
# plt.title("Confusion Matrix")
# plt.xlabel("Predicted")
# plt.ylabel("Actual")
# plt.show()


# Models to evaluate
models = {
    "Random Forest": RandomForestClassifier(random_state=42),
    "Decision Tree": DecisionTreeClassifier(random_state=42),
    "Ada Boost": AdaBoostClassifier(random_state=42),
    "Naive Bayes": GaussianNB(),
    "KNN": KNeighborsClassifier(),
    "Logistic Regression": LogisticRegression(max_iter=1000, random_state=42)

}

# Metrics storage
results = []
# Directory to save models
model_dir = "models"
os.makedirs(model_dir, exist_ok=True)  # Create the directory if it doesn't exist

# Train and evaluate each model
for model_name, model in models.items():
    print(f"Training and evaluating {model_name}...")
    
    # Train the model
    model.fit(X_train_scaled, y_train_enc)

    # Save the trained model to a joblib file in the specified folder
    model_file = os.path.join(model_dir, f"{model_name.replace(' ', '_')}.joblib")
    dump(model, model_file)
    print(f"{model_name} saved to {model_file}.")

    # Predict on test data
    y_pred = model.predict(X_test_scaled)
    
    # Calculate metrics
    acc = accuracy_score(y_test_enc, y_pred)
    precision = precision_score(y_test_enc, y_pred, average="weighted")
    recall = recall_score(y_test_enc, y_pred, average="weighted")
    f1 = f1_score(y_test_enc, y_pred, average="weighted")
    
    # Append results
    results.append({
        "Model": model_name,
        "Accuracy": acc,
        "Precision": precision,
        "Recall": recall,
        "F1 Score": f1
    })
    
    # Print confusion matrix and classification report
    print(f"\nConfusion Matrix for {model_name}:")
    print(confusion_matrix(y_test_enc, y_pred))
    
    print(f"\nClassification Report for {model_name}:")
    print(classification_report(y_test_enc, y_pred))
    print("-" * 50)

# Display results as a DataFrame
results_df = pd.DataFrame(results)
print("\nModel Comparison:")
print(results_df)

# Visualize results
import matplotlib.pyplot as plt
results_df.set_index("Model")[["Accuracy", "Precision", "Recall", "F1 Score"]].plot(kind="bar", figsize=(10, 6))
plt.title("Model Performance Comparison")
plt.ylabel("Score")
plt.xticks(rotation=45)
plt.legend(loc="lower right")
plt.show()
