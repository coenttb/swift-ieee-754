// IEEE_754.swift
// swift-ieee-754
//
// IEEE 754-2019: Standard for Floating-Point Arithmetic
//
// This namespace contains the authoritative implementations of the IEEE 754 standard.
// Structure follows the specification's binary interchange formats.

/// IEEE 754: Floating-Point Arithmetic Standard
///
/// ## Overview
///
/// Authoritative namespace for IEEE 754-2019 binary floating-point standard implementations.
/// This enum provides the canonical binary interchange formats for Swift's Float and Double types.
///
/// ## Binary Interchange Formats
///
/// - ``Binary32``: Single precision (32-bit) format for Float
/// - ``Binary64``: Double precision (64-bit) format for Double
///
/// ## Usage
///
/// Most users should use the convenience extensions on Double, Float, and [UInt8]:
///
/// ```swift
/// // Serialization
/// let bytes = value.bytes()
/// let bytes = value.bytes(endianness: .big)
///
/// // Deserialization
/// let value = Double(bytes: bytes)
/// let value = Double(bytes: bytes, endianness: .big)
/// ```
///
/// For direct access to the authoritative format implementations:
///
/// ```swift
/// // Binary64
/// let bytes = IEEE_754.Binary64.bytes(from: 3.14159)
/// let value = IEEE_754.Binary64.value(from: bytes)
///
/// // Binary32
/// let bytes = IEEE_754.Binary32.bytes(from: Float(3.14))
/// let value = IEEE_754.Binary32.value(from: bytes)
/// ```
///
/// ## Conformance
///
/// This implementation conforms to IEEE 754-2019:
/// - Binary interchange formats (Section 3.6)
/// - Correct special value handling (zero, infinity, NaN, subnormal)
/// - Sign and payload preservation for all values
///
/// ## Performance
///
/// Optimized for high-throughput scenarios:
/// - Zero-copy deserialization with unsafe memory operations
/// - Cross-module inlining via `@inlinable` and `@_transparent`
/// - ~3-4 microseconds per serialization/deserialization operation
///
/// ## See Also
///
/// - ``Binary32``
/// - ``Binary64``
public enum IEEE_754 {}
