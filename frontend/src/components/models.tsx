"use client";

import React, { useState } from "react";
import Image from 'next/image';

const ModelSelectionForm: React.FC = () => {
  const [graph, setGraph] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const handleModelSelect = async () => {
    setIsLoading(true);
    setError(null);

    try {
      const response = await fetch("http://localhost:5000/process", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (!response.ok) {
        throw new Error(`Error: ${response.statusText}`);
      }

      const data = await response.json();

      setGraph(data.graph); // Assuming `data.graph` contains the base64 image
    } catch (error) {
      setError(`Connection error: ${(error as Error).message}`);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center h-screen">
      <h2 className="text-2xl font-semibold mb-6 text-gray-800">
        Select a Model for Classification
      </h2>

      <button
        onClick={handleModelSelect}
        className="px-6 py-3 bg-blue-500 text-white font-medium rounded shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400"
      >
        Commence
      </button>

      {isLoading && <p className="mt-4 text-gray-600">Processing...</p>}

      {error && <p className="mt-4 text-red-500">{error}</p>}

      {graph && (
        <div className="my-6">
          <h3 className="text-lg font-semibold mb-2 text-gray-800">
            Prediction Graph
          <Image
            src={`data:image/png;base64,${graph}`}
            alt="Prediction Graph"
            className="border rounded-md"
            width={750} // Adjust width as needed
            height={500} // Adjust height as needed
          />
          </h3>
        </div>
      )}

      
    </div>
  );
};

export default ModelSelectionForm;
