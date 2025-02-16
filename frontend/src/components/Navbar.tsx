"use client"

import Link from "next/link"

export default function Navbar() {
  return (
    <div className="w-full border-b border-[#071739]/20">
      <nav className="max-w-[1400px] mx-auto flex justify-between items-center px-8 py-6">
        {/* Logo */}
        <div>
          <Link
            href="/"
            className="text-[#071739] font-mono text-2xl"
            style={{ fontFamily: "'IBM Plex Mono', monospace" }}
          >
            IDS.
          </Link>
        </div>

        {/* Navigation Links */}
        <div className="flex items-center space-x-12">
          <Link
            href="/"
            className="text-[#071739] text-lg hover:text-[#071739]/80 transition-colors"
            style={{ fontFamily: "'Inter', sans-serif" }}
          >
            Home
          </Link>
          <Link
            href="/about"
            className="text-[#071739] text-lg hover:text-[#071739]/80 transition-colors"
            style={{ fontFamily: "'Inter', sans-serif" }}
          >
            About
          </Link>
          <Link
            href="/contact"
            className="text-[#071739] text-lg hover:text-[#071739]/80 transition-colors"
            style={{ fontFamily: "'Inter', sans-serif" }}
          >
            Contact
          </Link>
        </div>
      </nav>
    </div>
  )
}

