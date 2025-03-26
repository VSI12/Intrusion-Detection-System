import { Button } from "@/components/ui/button"
import Link from "next/link"


export default function Home() {
  return (
    <div className="max-h-screen">
    <main className="max-w-[1400px] mx-auto px-8 pt-32">
      <h1 className="text-[#071739] text-6xl font-serif mb-4" style={{ fontFamily: "'Libre Baskerville', serif" }}>
        Network Traffic Classification
        <span className="block text-4xl italic mt-2" style={{ fontFamily: "'Libre Baskerville', serif" }}>
          Made Simple
        </span>
      </h1>

      <div className="space-y-1 mb-12 text-xl text-[#071739]/80" style={{ fontFamily: "'Inter', sans-serif" }}>
        <p>Easily analyze and classify network traffic for potential threats.</p>
        <p>Upload your data and get clear, actionable insights.</p>
        <p>Minimal set-up and expertise required.</p>
      </div>

      <div className="flex gap-6">
        <Link href="/upload-data">
          <Button
            className="bg-[#071739] hover:bg-[#071739]/90 text-white rounded-md px-8 py-6 text-lg"
            style={{ fontFamily: "'Inter', sans-serif" }}
            >
            Get Started
          </Button>
        </Link>
        <Button
          variant="outline"
          className="border-[#071739] text-[#071739] hover:bg-[#071739]/5 rounded-md px-8 py-6 text-lg"
          style={{ fontFamily: "'Inter', sans-serif" }}
        >
          Learn More
        </Button>
      </div>
    </main>
  </div>
  );
}
