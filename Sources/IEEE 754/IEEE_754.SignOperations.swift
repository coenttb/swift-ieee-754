// IEEE_754.SignOperations.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.5: Sign Bit Operations
// Authoritative implementations of sign manipulation operations

import Standards

// MARK: - IEEE 754 Sign Operations

extension IEEE_754 {
    /// IEEE 754 sign bit operations (Section 5.5)
    ///
    /// Implements the sign bit operations defined in IEEE 754-2019.
    /// These operations manipulate the sign bit of floating-point values.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines several sign bit operations:
    /// - `negate` - Reverse the sign bit
    /// - `abs` - Clear the sign bit (absolute value)
    /// - `copySign` - Copy sign bit from one value to another
    ///
    /// These operations work on the sign bit directly and preserve all other
    /// bits, including the payload of NaN values.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.5: Details of sign bit operations
    /// - IEEE 754-2019 Table 5.1: Required operations
    public enum SignOperations {}
}

// MARK: - Double Sign Operations

extension IEEE_754.SignOperations {
    /// Negate (reverse sign bit) - IEEE 754 `negate`
    ///
    /// Returns the value with its sign bit reversed. This operation works
    /// on the bit representation and preserves NaN payloads.
    ///
    /// - Parameter value: The value to negate
    /// - Returns: Value with reversed sign bit
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.negate(3.14)   // -3.14
    /// IEEE_754.SignOperations.negate(-3.14)  // 3.14
    /// IEEE_754.SignOperations.negate(0.0)    // -0.0
    /// IEEE_754.SignOperations.negate(-0.0)   // 0.0
    /// ```
    @inlinable
    public static func negate(_ value: Double) -> Double {
        -value
    }

    /// Absolute value (clear sign bit) - IEEE 754 `abs`
    ///
    /// Returns the value with its sign bit cleared. For NaN values,
    /// this preserves the payload.
    ///
    /// - Parameter value: The value
    /// - Returns: Value with sign bit cleared
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.abs(3.14)   // 3.14
    /// IEEE_754.SignOperations.abs(-3.14)  // 3.14
    /// IEEE_754.SignOperations.abs(-0.0)   // 0.0
    /// ```
    @inlinable
    public static func abs(_ value: Double) -> Double {
        Swift.abs(value)
    }

    /// Copy sign - IEEE 754 `copySign`
    ///
    /// Returns the magnitude of the first value with the sign of the second.
    /// This operation copies only the sign bit.
    ///
    /// - Parameters:
    ///   - magnitude: Value providing the magnitude
    ///   - sign: Value providing the sign
    /// - Returns: magnitude with sign from sign parameter
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.copySign(magnitude: 3.14, sign: -1.0)   // -3.14
    /// IEEE_754.SignOperations.copySign(magnitude: -3.14, sign: 1.0)   // 3.14
    /// IEEE_754.SignOperations.copySign(magnitude: 3.14, sign: -0.0)   // -3.14
    /// IEEE_754.SignOperations.copySign(magnitude: 0.0, sign: -1.0)    // -0.0
    /// ```
    @inlinable
    public static func copySign(magnitude: Double, sign: Double) -> Double {
        Double(sign: sign.sign, exponent: magnitude.exponent, significand: magnitude.significand)
    }
}

// MARK: - Float Sign Operations

extension IEEE_754.SignOperations {
    /// Negate (reverse sign bit) - IEEE 754 `negate`
    ///
    /// Returns the value with its sign bit reversed. This operation works
    /// on the bit representation and preserves NaN payloads.
    ///
    /// - Parameter value: The value to negate
    /// - Returns: Value with reversed sign bit
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.negate(Float(3.14))   // -3.14
    /// IEEE_754.SignOperations.negate(Float(-3.14))  // 3.14
    /// IEEE_754.SignOperations.negate(Float(0.0))    // -0.0
    /// ```
    @inlinable
    public static func negate(_ value: Float) -> Float {
        -value
    }

    /// Absolute value (clear sign bit) - IEEE 754 `abs`
    ///
    /// Returns the value with its sign bit cleared. For NaN values,
    /// this preserves the payload.
    ///
    /// - Parameter value: The value
    /// - Returns: Value with sign bit cleared
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.abs(Float(3.14))   // 3.14
    /// IEEE_754.SignOperations.abs(Float(-3.14))  // 3.14
    /// ```
    @inlinable
    public static func abs(_ value: Float) -> Float {
        Swift.abs(value)
    }

    /// Copy sign - IEEE 754 `copySign`
    ///
    /// Returns the magnitude of the first value with the sign of the second.
    /// This operation copies only the sign bit.
    ///
    /// - Parameters:
    ///   - magnitude: Value providing the magnitude
    ///   - sign: Value providing the sign
    /// - Returns: magnitude with sign from sign parameter
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.SignOperations.copySign(magnitude: Float(3.14), sign: Float(-1.0))  // -3.14
    /// IEEE_754.SignOperations.copySign(magnitude: Float(-3.14), sign: Float(1.0))  // 3.14
    /// ```
    @inlinable
    public static func copySign(magnitude: Float, sign: Float) -> Float {
        Float(sign: sign.sign, exponent: magnitude.exponent, significand: magnitude.significand)
    }
}
