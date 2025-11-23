// Double+IEEE_754.swift
// swift-ieee-754
//
// IEEE 754 extensions for Double (binary64)

import Standards

extension Double {
    /// Access to IEEE 754 binary64 constants and methods
    ///
    /// Provides namespaced access to IEEE 754 serialization functionality.
    ///
    /// Example:
    /// ```swift
    /// let bytes = value.ieee754.bytes()
    /// let pattern = value.ieee754.bitPattern
    /// ```
    public static var ieee754: IEEE754.Type {
        IEEE754.self
    }

    /// Access to IEEE 754 instance methods for this Double
    ///
    /// Provides namespaced access to IEEE 754 serialization functionality.
    ///
    /// Example:
    /// ```swift
    /// let bytes = (3.14159).ieee754.bytes()
    /// let bytes = (3.14159).ieee754.bytes(endianness: .big)
    /// ```
    public var ieee754: IEEE754 {
        IEEE754(double: self)
    }

    /// IEEE 754 namespace for Double
    ///
    /// Provides namespaced access to IEEE 754 binary64 serialization methods
    /// and properties for Double values.
    public struct IEEE754: Sendable {
        public let double: Double
    }
}

// MARK: - Canonical Deserialization

extension Double {
    /// Creates Double from IEEE 754 binary64 bytes
    ///
    /// Canonical deserialization following the FixedWidthInteger pattern.
    /// Converts an 8-byte array in IEEE 754 binary64 format back to a Double.
    ///
    /// - Parameters:
    ///   - bytes: 8-byte array in IEEE 754 binary64 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: nil if bytes.count ≠ 8
    ///
    /// Example:
    /// ```swift
    /// let value = Double(bytes: [0x18, 0x2D, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40])
    /// // Optional(3.141592653589793)
    ///
    /// let value = Double(bytes: data, endianness: .big)
    /// // Optional(someValue) or nil
    /// ```
    ///
    /// - Note: Returns `nil` for empty byte arrays (scalars require exactly 8 bytes).
    ///   For array deserialization of empty bytes, see `[Double].init(bytes:)` which
    ///   returns an empty array.
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/value(from:endianness:)``
    @_transparent
    public init?(bytes: [UInt8], endianness: [UInt8].Endianness = .little) {
        guard let value = IEEE_754.Binary64.value(from: bytes, endianness: endianness) else {
            return nil
        }
        self = value
    }
}

// MARK: - Canonical Serialization

extension Double {
    /// Returns IEEE 754 binary64 byte representation
    ///
    /// Canonical serialization following the FixedWidthInteger pattern.
    /// Converts the Double to an 8-byte array in IEEE 754 binary64 format.
    ///
    /// - Parameter endianness: Byte order (defaults to little-endian)
    /// - Returns: 8-byte array in IEEE 754 binary64 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = (3.14159).bytes()
    /// // [0x6E, 0x86, 0x1B, 0xF0, 0xF9, 0x21, 0x09, 0x40]
    ///
    /// let bytes = value.bytes(endianness: .big)  // Network byte order
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/bytes(from:endianness:)``
    @_transparent
    public func bytes(endianness: [UInt8].Endianness = .little) -> [UInt8] {
        IEEE_754.Binary64.bytes(from: self, endianness: endianness)
    }
}

// MARK: - Type-level Methods

extension Double {
    /// Creates Double from IEEE 754 binary64 bytes
    ///
    /// Type-level deserialization method. Converts an 8-byte array in IEEE 754
    /// binary64 format to a Double.
    ///
    /// - Parameters:
    ///   - bytes: 8-byte array in IEEE 754 binary64 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: Double value, or nil if bytes.count ≠ 8
    ///
    /// Example:
    /// ```swift
    /// let value = Double.ieee754([0x18, 0x2D, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40])
    /// // Optional(3.141592653589793)
    ///
    /// let value = Double.ieee754(bytes, endianness: .big)
    /// // Optional(someValue) or nil
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/value(from:endianness:)``
    @_transparent
    public static func ieee754(
        _ bytes: [UInt8],
        endianness: [UInt8].Endianness = .little
    ) -> Double? {
        IEEE_754.Binary64.value(from: bytes, endianness: endianness)
    }
}

// MARK: - Instance Methods

extension Double.IEEE754 {
    /// Returns IEEE 754 binary64 byte representation
    ///
    /// Namespaced serialization method. Converts the Double to an 8-byte array
    /// in IEEE 754 binary64 format.
    ///
    /// - Parameter endianness: Byte order (defaults to little-endian)
    /// - Returns: 8-byte array in IEEE 754 binary64 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = (3.14159).ieee754.bytes()
    /// let bytes = (3.14159).ieee754.bytes(endianness: .big)
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/bytes(from:endianness:)``
    @_transparent
    public func bytes(endianness: [UInt8].Endianness = .little) -> [UInt8] {
        IEEE_754.Binary64.bytes(from: double, endianness: endianness)
    }

    /// Returns the IEEE 754 binary64 bit pattern
    ///
    /// Direct access to the underlying 64-bit representation of the Double value.
    ///
    /// Example:
    /// ```swift
    /// let pattern = (3.14159).ieee754.bitPattern
    /// // 0x400921FB54442D18
    /// ```
    @_transparent
    public var bitPattern: UInt64 {
        double.bitPattern
    }
}
