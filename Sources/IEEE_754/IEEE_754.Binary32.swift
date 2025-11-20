// IEEE_754.Binary32.swift
// swift-ieee-754
//
// IEEE 754 binary32 (single precision) format

import Standards

extension IEEE_754 {
    /// IEEE 754 binary32 (single precision) format
    ///
    /// ## Format Specification (IEEE 754-2019 Section 3.6)
    ///
    /// Total: 32 bits (4 bytes)
    /// - Sign: 1 bit
    /// - Exponent: 8 bits (biased by 127)
    /// - Significand: 23 bits (plus implicit leading 1)
    ///
    /// ## Encoding
    ///
    /// ```
    /// seee eeee efff ffff ffff ffff ffff ffff
    /// │└──┬──┘ └────────────┬──────────────┘
    /// │ exponent      significand
    /// sign      (23 bits)
    /// (8 bits)
    /// ```
    ///
    /// ## Special Values
    ///
    /// - Zero: exponent = 0, fraction = 0
    /// - Subnormal: exponent = 0, fraction ≠ 0
    /// - Infinity: exponent = 255, fraction = 0
    /// - NaN: exponent = 255, fraction ≠ 0
    ///
    /// ## Overview
    ///
    /// Binary32 corresponds to Swift's `Float` type. This namespace provides
    /// the canonical binary serialization and deserialization:
    /// ```
    /// Float ↔ [UInt8] (IEEE 754 binary32 bytes)
    /// ```
    public enum Binary32 {
        /// Number of bytes in binary32 format
        public static let byteSize: Int = 4

        /// Number of bits in binary32 format
        public static let bitSize: Int = 32

        /// Sign bit: 1 bit
        public static let signBits: Int = 1

        /// Exponent bits: 8 bits
        public static let exponentBits: Int = 8

        /// Significand bits: 23 bits (plus implicit leading 1)
        public static let significandBits: Int = 23

        /// Exponent bias: 127
        public static let exponentBias: Int = 127

        /// Maximum exponent value (before bias)
        public static let maxExponent: Int = (1 << exponentBits) - 1
    }
}

extension IEEE_754.Binary32 {
    /// Serializes Float to IEEE 754 binary32 byte representation
    ///
    /// Authoritative serialization method. Converts a Float to a 4-byte array
    /// in IEEE 754 binary32 format. This is a lossless transformation preserving
    /// all bits of the floating-point value.
    ///
    /// - Parameters:
    ///   - value: Float to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    /// - Returns: 4-byte array in IEEE 754 binary32 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = IEEE_754.Binary32.bytes(from: Float(3.14))
    /// let bytes = IEEE_754.Binary32.bytes(from: Float(3.14), endianness: .big)
    /// ```
    @inlinable
    public static func bytes(
        from value: Float,
        endianness: [UInt8].Endianness = .little
    ) -> [UInt8] {
        let bitPattern = value.bitPattern
        return [UInt8](bitPattern, endianness: endianness)
    }

    /// Deserializes IEEE 754 binary32 bytes to Float
    ///
    /// Authoritative deserialization method. Converts a 4-byte array in
    /// IEEE 754 binary32 format back to a Float. This is the inverse of
    /// the serialization operation, preserving all bits of the original value.
    ///
    /// - Parameters:
    ///   - bytes: 4-byte array in IEEE 754 binary32 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: Float value, or nil if bytes.count ≠ 4
    ///
    /// Example:
    /// ```swift
    /// let value = IEEE_754.Binary32.value(from: bytes)
    /// let value = IEEE_754.Binary32.value(from: bytes, endianness: .big)
    /// ```
    @inlinable
    public static func value(
        from bytes: [UInt8],
        endianness: [UInt8].Endianness = .little
    ) -> Float? {
        guard bytes.count == byteSize else { return nil }

        let bitPattern: UInt32 = bytes.withUnsafeBytes { buffer in
            let loaded = buffer.loadUnaligned(fromByteOffset: 0, as: UInt32.self)
            switch endianness {
            case .little:
                return UInt32(littleEndian: loaded)
            case .big:
                return UInt32(bigEndian: loaded)
            }
        }

        return Float(bitPattern: bitPattern)
    }
}
