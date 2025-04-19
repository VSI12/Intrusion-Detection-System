"use client";

import { useState } from "react";
import { CloudUpload } from "lucide-react";
import { Button } from "@/components/ui/button";

import Image from "next/image";

export default function UploadPage() {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [uploadStatus, setUploadStatus] = useState<{ status: string; message?: string }>({ status: "" });
  const [predictions, setPredictions] = useState<{ normal: number; malicious: number } | null>(null);

  const [graph, setGraph] = useState<string | null>(null);

  // Handle file selection
  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files[0]) {
      setSelectedFile(event.target.files[0]);
    }
  };

  // Upload file and get results
  const uploadFile = async () => {
    if (!selectedFile) {
      setUploadStatus({ status: "error", message: "Please select a file first." });
      return;
    }

    try {
      const formData = new FormData();
      formData.append("file", selectedFile);

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/upload`, {
        method: "POST",
        body: formData,
      });

      if (!response.ok) throw new Error("Failed to upload to Flask");

      const result = await response.json();
      setUploadStatus({ status: "success", message: result.message });

      // Store the predictions and graph
      setPredictions({
        normal: result.predictions.normal,
        malicious: result.predictions.malicious
      });
      setGraph(result.graph ? `data:image/png;base64,${result.graph}` : null);
    } catch (error) {
      setUploadStatus({ status: "error", message: `Error: ${(error as Error).message}` });
    }
  };

  return (
    <div className="max-h-screen">
      <main className="max-w-[1400px] mx-auto px-8 pt-20">
        <h1 className="text-center text-4xl text-[#071739] mb-12" style={{ fontFamily: "'Libre Baskerville', serif" }}>
          Upload your network data for classification
        </h1>

        <div className="max-w-2xl mx-auto bg-[#071739] rounded-3xl p-12">
          <form onSubmit={(e) => e.preventDefault()} className="flex flex-col items-center space-y-6">
            <CloudUpload className="w-16 h-16 text-white mb-4" />

            <p className="text-white text-xl mt-6 mb-8" style={{ fontFamily: "'Inter', sans-serif" }}>
              Please choose your file
            </p>

            <div className="flex gap-8">
              <div className="relative">
                <input
                  type="file"
                  accept=".csv"
                  onChange={handleFileChange}
                  className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
                />
                <Button
                  type="button"
                  variant="secondary"
                  className="bg-[#E5E9F0] hover:bg-[#E5E9F0]/90 text-[#071739] px-8 py-6 text-lg rounded-md"
                  style={{ fontFamily: "'Inter', sans-serif" }}
                >
                  Choose file
                </Button>
              </div>

              <Button
                type="button"
                variant="secondary"
                disabled={!selectedFile}
                onClick={uploadFile}
                className="bg-[#E5E9F0] hover:bg-[#E5E9F0]/90 text-[#071739] px-8 py-6 text-lg rounded-md"
                style={{ fontFamily: "'Inter', sans-serif" }}
              >
                Upload File
              </Button>
            </div>

            {selectedFile && <p className="text-white mt-4">Selected file: {selectedFile.name}</p>}

            {uploadStatus.status && (
              <p
                className={`mt-4 text-lg ${uploadStatus.status === "success" ? "text-green-500" : "text-red-500"}`}
                style={{ fontFamily: "'Inter', sans-serif" }}
              >
                {uploadStatus.message}
              </p>
            )}
          </form>

          {/* Display Predictions Summary */}
          {predictions && (
            <div className="mt-6">
              <h2 className="text-white text-2xl mb-4">Prediction Summary:</h2>
              <div className="text-white text-lg flex gap-8">
                <p>🟢 Normal: {predictions.normal}</p>
                <p>🔴 Malicious: {predictions.malicious}</p>
              </div>
            </div>
          )}

          {/* Display Graph */}
          {graph && (
            <div className="mt-6">
              <h2 className="text-white text-2xl mb-4">Graph:</h2>
              <Image 
                src={graph} 
                alt="Prediction Graph"
                width={500} // Adjust as needed
                height={300} // Adjust as needed
                className="border border-gray-300 rounded-md"
              />
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
