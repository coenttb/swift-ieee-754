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
    /// ## Category Theory
    ///
    /// Binary32 is Swift's `Float` type. This namespace provides the
    /// canonical transformation:
    /// ```
    /// Float ←→ [UInt8] (IEEE 754 binary32 bytes)
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
    /// ## Category Theory
    ///
    /// Natural transformation:
    /// ```
    /// Float → [UInt8] (binary32)
    /// ```
    ///
    /// Lossless, bijective mapping to canonical binary interchange format.
    ///
    /// - Parameters:
    ///   - value: Float to serialize
    ///   - endianness: Byte order (little or big)
    /// - Returns: 4-byte array in IEEE 754 binary32 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = IEEE_754.Binary32.bytes(from: Float(3.14))
    /// let bytes = IEEE_754.Binary32.bytes(from: Float(3.14), endianness: .big)
    /// ```
    public static func bytes(
        from value: Float,
        endianness: [UInt8].Endianness = .little
    ) -> [UInt8] {
        let bitPattern = value.bitPattern
        return [UInt8](bitPattern, endianness: endianness)
    }

    /// Deserializes IEEE 754 binary32 bytes to Float
    ///
    /// ## Category Theory
    ///
    /// Natural transformation (inverse of serialization):
    /// ```
    /// [UInt8] (binary32) → Float
    /// ```
    ///
    /// - Parameters:
    ///   - bytes: 4-byte array in IEEE 754 binary32 format
    ///   - endianness: Byte order of input bytes
    /// - Returns: Float value, or nil if bytes.count ≠ 4
    ///
    /// Example:
    /// ```swift
    /// let value = IEEE_754.Binary32.value(from: bytes)
    /// let value = IEEE_754.Binary32.value(from: bytes, endianness: .big)
    /// ```
    public static func value(
        from bytes: [UInt8],
        endianness: [UInt8].Endianness = .little
    ) -> Float? {
        guard bytes.count == byteSize else { return nil }

        var bitPattern: UInt32 = 0
        switch endianness {
        case .little:
            for (index, byte) in bytes.enumerated() {
                bitPattern |= UInt32(byte) << (index * 8)
            }
        case .big:
            for (index, byte) in bytes.enumerated() {
                bitPattern |= UInt32(byte) << ((3 - index) * 8)
            }
        }

        return Float(bitPattern: bitPattern)
    }
}
