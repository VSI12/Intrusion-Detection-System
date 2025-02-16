"use client"; // Ensure it's a client component for interactivity
import Link from "next/link";

export default function Navbar() {
  return (
    <nav className="w-full flex justify-between items-center p-4 bg-white shadow-md">
      {/* Logo */}
      <div className="text-2xl font-bold">
        <Link href="/">IDS.</Link>
      </div>

      {/* Navigation Links */}
      <div className="space-x-6 hidden md:flex">
        <Link href="/" className="text-gray-700 hover:text-blue-500">
          Home
        </Link>
        <Link href="/about" className="text-gray-700 hover:text-blue-500">
          About
        </Link>
        <Link href="/contact" className="text-gray-700 hover:text-blue-500">
          Contact
        </Link>
      </div>
    </nav>
  );
}
