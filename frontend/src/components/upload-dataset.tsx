"use client"

import { useState } from "react";

// Type definition for file state and upload status
interface UploadStatus {
  status: string;
  message?: string;
}

const UploadDataset = () => {
  const [file, setFile] = useState<File | null>(null);
  const [uploadStatus, setUploadStatus] = useState<UploadStatus>({ status: "" });

  // Handle file selection
  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files) {
      setFile(event.target.files[0]);
    }
  };

  // Upload the file to S3
  const uploadFile = async () => {
    if (!file) {
      setUploadStatus({ status: "error", message: "Please select a file first." });
      return;
    }

    try {
      // Step 1: Get the presigned URL from the backend
      const response = await fetch("http://localhost:5000/generate-presigned-url", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          file_name: file.name,
          file_type: file.type,
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to get presigned URL");
      }

      const { url } = await response.json();

      // Step 2: Upload the file to S3 using the presigned URL
      const uploadResponse = await fetch(url, {
        method: "PUT",
        headers: {
          "Content-Type": file.type,
        },
        body: file,
      });

      if (uploadResponse.ok) {
        setUploadStatus({ status: "success", message: "File uploaded successfully!" });
      } else {
        throw new Error("Failed to upload file to S3");
      }
    } catch (error) {
      setUploadStatus({ status: "error", message: `Error: ${(error as Error).message}` });
    }
  };

  return (
    <div>
      <h1>Upload Dataset</h1>
      <input type="file" onChange={handleFileChange} />
      <button onClick={uploadFile}>Upload</button>
      {uploadStatus.status && <p>{uploadStatus.message}</p>}
    </div>
  );
};

export default UploadDataset;
