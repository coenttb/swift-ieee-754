// Float+IEEE_754.swift
// swift-ieee-754
//
// IEEE 754 extensions for Float (binary32)

import Standards

extension Float {
    /// Access to IEEE 754 binary32 constants and methods
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

    /// Access to IEEE 754 instance methods for this Float
    ///
    /// Provides namespaced access to IEEE 754 serialization functionality.
    ///
    /// Example:
    /// ```swift
    /// let bytes = Float(3.14).ieee754.bytes()
    /// let bytes = Float(3.14).ieee754.bytes(endianness: .big)
    /// ```
    public var ieee754: IEEE754 {
        IEEE754(float: self)
    }

    /// IEEE 754 namespace for Float
    ///
    /// Provides namespaced access to IEEE 754 binary32 serialization methods
    /// and properties for Float values.
    public struct IEEE754: Sendable {
        public let float: Float
    }
}

// MARK: - Canonical Deserialization

extension Float {
    /// Creates Float from IEEE 754 binary32 bytes
    ///
    /// Canonical deserialization following the FixedWidthInteger pattern.
    /// Converts a 4-byte array in IEEE 754 binary32 format back to a Float.
    ///
    /// - Parameters:
    ///   - bytes: 4-byte array in IEEE 754 binary32 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: nil if bytes.count ≠ 4
    ///
    /// Example:
    /// ```swift
    /// let value = Float(bytes: [0xD0, 0x0F, 0x49, 0x40])
    /// // Optional(3.14159)
    ///
    /// let value = Float(bytes: data, endianness: .big)
    /// // Optional(someValue) or nil
    /// ```
    ///
    /// - Note: Returns `nil` for empty byte arrays (scalars require exactly 4 bytes).
    ///   For array deserialization of empty bytes, see `[Float].init(bytes:)` which
    ///   returns an empty array.
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/value(from:endianness:)``
    @_transparent
    public init?(bytes: [UInt8], endianness: [UInt8].Endianness = .little) {
        guard let value = IEEE_754.Binary32.value(from: bytes, endianness: endianness) else {
            return nil
        }
        self = value
    }
}

// MARK: - Canonical Serialization

extension Float {
    /// Returns IEEE 754 binary32 byte representation
    ///
    /// Canonical serialization following the FixedWidthInteger pattern.
    /// Converts the Float to a 4-byte array in IEEE 754 binary32 format.
    ///
    /// - Parameter endianness: Byte order (defaults to little-endian)
    /// - Returns: 4-byte array in IEEE 754 binary32 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = Float(3.14159).bytes()
    /// // [0xD0, 0x0F, 0x49, 0x40]
    ///
    /// let bytes = value.bytes(endianness: .big)  // Network byte order
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/bytes(from:endianness:)``
    @_transparent
    public func bytes(endianness: [UInt8].Endianness = .little) -> [UInt8] {
        IEEE_754.Binary32.bytes(from: self, endianness: endianness)
    }
}

// MARK: - Type-level Methods

extension Float {
    /// Creates Float from IEEE 754 binary32 bytes
    ///
    /// Type-level deserialization method. Converts a 4-byte array in IEEE 754
    /// binary32 format to a Float.
    ///
    /// - Parameters:
    ///   - bytes: 4-byte array in IEEE 754 binary32 format
    ///   - endianness: Byte order of input bytes (defaults to little-endian)
    /// - Returns: Float value, or nil if bytes.count ≠ 4
    ///
    /// Example:
    /// ```swift
    /// let value = Float.ieee754([0xD0, 0x0F, 0x49, 0x40])
    /// // Optional(3.14159)
    ///
    /// let value = Float.ieee754(bytes, endianness: .big)
    /// // Optional(someValue) or nil
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/value(from:endianness:)``
    @_transparent
    public static func ieee754(
        _ bytes: [UInt8],
        endianness: [UInt8].Endianness = .little
    ) -> Float? {
        IEEE_754.Binary32.value(from: bytes, endianness: endianness)
    }
}

// MARK: - Instance Methods

extension Float.IEEE754 {
    /// Returns IEEE 754 binary32 byte representation
    ///
    /// Namespaced serialization method. Converts the Float to a 4-byte array
    /// in IEEE 754 binary32 format.
    ///
    /// - Parameter endianness: Byte order (defaults to little-endian)
    /// - Returns: 4-byte array in IEEE 754 binary32 format
    ///
    /// Example:
    /// ```swift
    /// let bytes = Float(3.14).ieee754.bytes()
    /// let bytes = Float(3.14).ieee754.bytes(endianness: .big)
    /// ```
    ///
    /// - Note: Delegates to ``IEEE_754/Binary32/bytes(from:endianness:)``
    @_transparent
    public func bytes(endianness: [UInt8].Endianness = .little) -> [UInt8] {
        IEEE_754.Binary32.bytes(from: float, endianness: endianness)
    }

    /// Returns the IEEE 754 binary32 bit pattern
    ///
    /// Direct access to the underlying 32-bit representation of the Float value.
    ///
    /// Example:
    /// ```swift
    /// let pattern = Float(3.14).ieee754.bitPattern
    /// // 0x4048F5C3
    /// ```
    @_transparent
    public var bitPattern: UInt32 {
        float.bitPattern
    }
}
