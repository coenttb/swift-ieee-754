// [UInt8]+IEEE_754.swift
// swift-ieee-754
//
// Convenient namespaced access to IEEE 754 serialization

import Standards

extension [UInt8] {
    /// Access to IEEE 754 type-level constants and methods
    ///
    /// Provides namespaced access to IEEE 754 serialization functionality
    /// for creating byte arrays from Float and Double values.
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8].ieee754.bytes(from: 3.14159)
    /// ```
    public static var ieee754: IEEE754.Type {
        IEEE754.self
    }

    /// Access to IEEE 754 instance methods for this byte array
    ///
    /// Provides namespaced access to IEEE 754 deserialization functionality.
    public var ieee754: IEEE754 {
        IEEE754(bytes: self)
    }

    /// IEEE 754 namespace for [UInt8]
    ///
    /// Provides namespaced access to IEEE 754 serialization methods for
    /// converting Float and Double values to byte arrays.
    public struct IEEE754: Sendable {
        public let bytes: [UInt8]
    }
}

// MARK: - Type-level Methods (Serialization)

extension [UInt8].IEEE754 {
    /// Creates byte array from Double using IEEE 754 binary64 format
    ///
    /// Namespaced serialization method. Converts a Double to an 8-byte array
    /// in IEEE 754 binary64 format.
    ///
    /// - Parameters:
    ///   - value: Double to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    /// - Returns: 8-byte array in IEEE 754 binary64 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8].ieee754.bytes(from: 3.14159)
    /// let bytes = [UInt8].ieee754.bytes(from: 3.14159, endianness: .big)
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/bytes(from:endianness:)``
    public static func bytes(
        from value: Double,
        endianness: [UInt8].Endianness = .little
    ) -> [UInt8] {
        IEEE_754.Binary64.bytes(from: value, endianness: endianness)
    }

    /// Creates byte array from Float using IEEE 754 binary32 format
    ///
    /// Namespaced serialization method. Converts a Float to a 4-byte array
    /// in IEEE 754 binary32 format.
    ///
    /// - Parameters:
    ///   - value: Float to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    /// - Returns: 4-byte array in IEEE 754 binary32 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8].ieee754.bytes(from: Float(3.14))
    /// let bytes = [UInt8].ieee754.bytes(from: Float(3.14), endianness: .big)
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/bytes(from:endianness:)``
    public static func bytes(
        from value: Float,
        endianness: [UInt8].Endianness = .little
    ) -> [UInt8] {
        IEEE_754.Binary32.bytes(from: value, endianness: endianness)
    }
}

// MARK: - Canonical [UInt8] Initializers

extension [UInt8] {
    /// Creates byte array from Double using IEEE 754 binary64 format
    ///
    /// Canonical serialization following the FixedWidthInteger pattern.
    /// Converts a Double to an 8-byte array in IEEE 754 binary64 format.
    ///
    /// - Parameters:
    ///   - value: Double to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8](3.14159)
    /// // [0x6E, 0x86, 0x1B, 0xF0, 0xF9, 0x21, 0x09, 0x40]
    ///
    /// let bytes = [UInt8](3.14159, endianness: .big)  // Network byte order
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary64/bytes(from:endianness:)``
    public init(_ value: Double, endianness: Endianness = .little) {
        self = IEEE_754.Binary64.bytes(from: value, endianness: endianness)
    }

    /// Creates byte array from Float using IEEE 754 binary32 format
    ///
    /// Canonical serialization following the FixedWidthInteger pattern.
    /// Converts a Float to a 4-byte array in IEEE 754 binary32 format.
    ///
    /// - Parameters:
    ///   - value: Float to serialize
    ///   - endianness: Byte order (defaults to little-endian)
    ///
    /// Example:
    /// ```swift
    /// let bytes = [UInt8](Float(3.14))
    /// // [0xC3, 0xF5, 0x48, 0x40]
    ///
    /// let bytes = [UInt8](Float(3.14), endianness: .big)  // Network byte order
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/bytes(from:endianness:)``
    public init(_ value: Float, endianness: Endianness = .little) {
        self = IEEE_754.Binary32.bytes(from: value, endianness: endianness)
    }
}
