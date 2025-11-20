// IEEE_754.Binary64.swift
// swift-ieee-754
//
// IEEE 754 binary64 (double precision) format

import Standards

extension IEEE_754 {
    /// IEEE 754 binary64 (double precision) format
    ///
    /// ## Format Specification (IEEE 754-2019 Section 3.6)
    ///
    /// Total: 64 bits (8 bytes)
    /// - Sign: 1 bit
    /// - Exponent: 11 bits (biased by 1023)
    /// - Significand: 52 bits (plus implicit leading 1)
    ///
    /// ## Encoding
    ///
    /// ```
    /// seee eeee eeee ffff ... ffff
    /// │└────┬────┘ └──────┬──────┘
    /// │  exponent    significand
    /// sign (52 bits)
    /// (11 bits)
    /// ```
    ///
    /// ## Special Values
    ///
    /// - Zero: exponent = 0, fraction = 0
    /// - Subnormal: exponent = 0, fraction ≠ 0
    /// - Infinity: exponent = 2047, fraction = 0
    /// - NaN: exponent = 2047, fraction ≠ 0
    ///
    /// ## Overview
    ///
    /// Binary64 corresponds to Swift's `Double` type. This namespace provides
    /// the canonical binary serialization and deserialization:
    /// ```
    /// Double ↔ [UInt8] (IEEE 754 binary64 bytes)
    /// ```
    public enum Binary64 {
        /// Number of bytes in binary64 format
        public static let byteSize: Int = 8

        /// Number of bits in binary64 format
        public static let bitSize: Int = 64

        /// Sign bit: 1 bit
        public static let signBits: Int = 1

        /// Exponent bits: 11 bits
        public static let exponentBits: Int = 11

        /// Significand bits: 52 bits (plus implicit leading 1)
        public static let significandBits: Int = 52

        /// Exponent bias: 1023
        public static let exponentBias: Int = 1023

        /// Maximum exponent value (before bias)
        public static let maxExponent: Int = (1 << exponentBits) - 1
    }
}

extension IEEE_754.Binary64 {
    /// Serializes Double to IEEE 754 binary64 byte representation
    ///
    /// Authoritative serialization method. Converts a Double to an 8-byte array
    /// in IEEE 754 binary64 format. This is a lossless transformation preserving
    /// all bits of the floating-point value.
    ///
    /// - Parameters:
    ///   - value: Double to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    /// - Returns: 8-byte array in IEEE 754 binary64 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = IEEE_754.Binary64.bytes(from: 3.14159)
    /// let bytes = IEEE_754.Binary64.bytes(from: 3.14159, endianness: .big)
    /// ```
    @inlinable
    public static func bytes(
        from value: Double,
        endianness: [UInt8].Endianness = .little
    ) -> [UInt8] {
        let bitPattern = value.bitPattern
        return [UInt8](bitPattern, endianness: endianness)
    }

    /// Deserializes IEEE 754 binary64 bytes to Double
    ///
    /// Authoritative deserialization method. Converts an 8-byte array in
    /// IEEE 754 binary64 format back to a Double. This is the inverse of
    /// the serialization operation, preserving all bits of the original value.
    ///
    /// - Parameters:
    ///   - bytes: 8-byte array in IEEE 754 binary64 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: Double value, or nil if bytes.count ≠ 8
    ///
    /// Example:
    /// ```swift
    /// let value = IEEE_754.Binary64.value(from: bytes)
    /// let value = IEEE_754.Binary64.value(from: bytes, endianness: .big)
    /// ```
    @inlinable
    public static func value(
        from bytes: [UInt8],
        endianness: [UInt8].Endianness = .little
    ) -> Double? {
        guard bytes.count == byteSize else { return nil }

        let bitPattern: UInt64 = bytes.withUnsafeBytes { buffer in
            let loaded = buffer.loadUnaligned(fromByteOffset: 0, as: UInt64.self)
            switch endianness {
            case .little:
                return UInt64(littleEndian: loaded)
            case .big:
                return UInt64(bigEndian: loaded)
            }
        }

        return Double(bitPattern: bitPattern)
    }
}
