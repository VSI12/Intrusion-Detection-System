"use client";

import React from "react";

const ModelSelectionForm: React.FC = () => {
  const handleModelSelect = async () => {
    try {
      const response = await fetch("http://localhost:5000/process", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
      });

      if (response.ok) {
        alert("Model submitted successfully!");
      } else {
        alert(`Error: ${response.statusText}`);
      }
    } catch (error) {
      alert(`Connection error: ${error}`);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center h-screen bg-gray-100">
      <h2 className="text-2xl font-semibold mb-6 text-gray-800">
        Select a Model for Classification
      </h2>
      <button
        onClick={handleModelSelect}
        className="px-6 py-3 bg-blue-500 text-white font-medium rounded shadow hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400"
      >
        Commence
      </button>
    </div>
  );
};

export default ModelSelectionForm;
