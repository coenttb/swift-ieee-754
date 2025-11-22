// IEEE_754.Conversions.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.4: Conversion Operations
// Authoritative implementations of format conversion operations

import Standards

// MARK: - IEEE 754 Conversion Operations

extension IEEE_754 {
    /// IEEE 754 conversion operations (Section 5.4)
    ///
    /// Implements the format conversion operations defined in IEEE 754-2019.
    /// These operations convert between different floating-point formats and
    /// between floating-point and integer representations.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines several conversion operations:
    ///
    /// ### Format Conversions
    /// - Between floating-point formats (e.g., Float ↔ Double)
    /// - Preserves value when possible, rounds when necessary
    ///
    /// ### Integer Conversions
    /// - `convertToInteger` - Convert to integer with specified rounding
    /// - `convertFromInteger` - Convert from integer to floating-point
    ///
    /// ### String Conversions
    /// - Decimal string to floating-point
    /// - Floating-point to decimal string
    ///
    /// ## Rounding
    ///
    /// When converting from a wider to narrower format, rounding may occur
    /// according to the current rounding mode. Values outside the target range
    /// may overflow to infinity or underflow to zero.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.4: Conversion operations for floating-point formats
    /// - IEEE 754-2019 Section 5.4.1: Conversion operations for binary formats
    public enum Conversions {}
}

// MARK: - Format Conversions

extension IEEE_754.Conversions {
    /// Convert Float to Double - IEEE 754 `convertFormat`
    ///
    /// Converts a Float (binary32) to Double (binary64). This conversion is
    /// always exact as Double has sufficient precision to represent any Float value.
    ///
    /// - Parameter value: The Float value
    /// - Returns: The value as Double
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Conversions.floatToDouble(Float(3.14))  // 3.14 (as Double)
    /// IEEE_754.Conversions.floatToDouble(Float.nan)    // Double.nan
    /// IEEE_754.Conversions.floatToDouble(Float.infinity)  // Double.infinity
    /// ```
    ///
    /// Note: This conversion is always exact and never rounds.
    @inlinable
    public static func floatToDouble(_ value: Float) -> Double {
        Double(value)
    }

    /// Convert Double to Float - IEEE 754 `convertFormat`
    ///
    /// Converts a Double (binary64) to Float (binary32). This conversion may
    /// round if the Double value cannot be exactly represented in Float.
    /// Values outside Float's range overflow to infinity or underflow to zero.
    ///
    /// - Parameter value: The Double value
    /// - Returns: The value as Float
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Conversions.doubleToFloat(3.14)  // Float(3.14)
    /// IEEE_754.Conversions.doubleToFloat(1e308) // Float.infinity (overflow)
    /// IEEE_754.Conversions.doubleToFloat(1e-50) // 0.0 (underflow)
    /// ```
    ///
    /// Note: This conversion may lose precision and may round according to the
    /// current rounding mode.
    @inlinable
    public static func doubleToFloat(_ value: Double) -> Float {
        Float(value)
    }

    #if canImport(FloatingPointTypes) && compiler(>=5.9)
    /// Convert Float16 to Float - IEEE 754 `convertFormat`
    ///
    /// Converts a Float16 (binary16) to Float (binary32). This conversion is
    /// always exact.
    ///
    /// - Parameter value: The Float16 value
    /// - Returns: The value as Float
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @inlinable
    public static func float16ToFloat(_ value: Float16) -> Float {
        Float(value)
    }

    /// Convert Float to Float16 - IEEE 754 `convertFormat`
    ///
    /// Converts a Float (binary32) to Float16 (binary16). This conversion may
    /// round and may overflow/underflow.
    ///
    /// - Parameter value: The Float value
    /// - Returns: The value as Float16
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @inlinable
    public static func floatToFloat16(_ value: Float) -> Float16 {
        Float16(value)
    }

    /// Convert Float16 to Double - IEEE 754 `convertFormat`
    ///
    /// Converts a Float16 (binary16) to Double (binary64). This conversion is
    /// always exact.
    ///
    /// - Parameter value: The Float16 value
    /// - Returns: The value as Double
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @inlinable
    public static func float16ToDouble(_ value: Float16) -> Double {
        Double(value)
    }

    /// Convert Double to Float16 - IEEE 754 `convertFormat`
    ///
    /// Converts a Double (binary64) to Float16 (binary16). This conversion may
    /// round and may overflow/underflow.
    ///
    /// - Parameter value: The Double value
    /// - Returns: The value as Float16
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @inlinable
    public static func doubleToFloat16(_ value: Double) -> Float16 {
        Float16(value)
    }
    #endif
}

// MARK: - Integer Conversions

extension IEEE_754.Conversions {
    /// Convert floating-point to integer - IEEE 754 `convertToIntegerTiesToEven`
    ///
    /// Converts a Double to Int, rounding toward nearest (ties to even).
    /// Returns nil if the value is NaN, infinite, or outside Int range.
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The integer value, or nil if conversion fails
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Conversions.doubleToInt(3.14)   // 3
    /// IEEE_754.Conversions.doubleToInt(3.5)    // 4 (ties to even)
    /// IEEE_754.Conversions.doubleToInt(4.5)    // 4 (ties to even)
    /// IEEE_754.Conversions.doubleToInt(.nan)   // nil
    /// ```
    @inlinable
    public static func doubleToInt(_ value: Double) -> Int? {
        // Check for special values
        if value.isNaN || value.isInfinite {
            return nil
        }

        // Check for out of range
        let minInt = Double(Int.min)
        let maxInt = Double(Int.max)
        if value < minInt || value > maxInt {
            return nil
        }

        // Round to nearest (ties to even) and convert
        let rounded = value.rounded(.toNearestOrEven)
        return Int(rounded)
    }

    /// Convert floating-point to integer with truncation
    ///
    /// Converts a Double to Int, rounding toward zero (truncation).
    /// Returns nil if the value is NaN, infinite, or outside Int range.
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The integer value, or nil if conversion fails
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Conversions.doubleToIntTruncating(3.9)   // 3
    /// IEEE_754.Conversions.doubleToIntTruncating(-3.9)  // -3
    /// ```
    @inlinable
    public static func doubleToIntTruncating(_ value: Double) -> Int? {
        if value.isNaN || value.isInfinite {
            return nil
        }

        let minInt = Double(Int.min)
        let maxInt = Double(Int.max)
        if value < minInt || value > maxInt {
            return nil
        }

        return Int(value)  // Swift's Int() truncates
    }

    /// Convert integer to floating-point - IEEE 754 `convertFromInt`
    ///
    /// Converts an Int to Double. This conversion may round if the Int value
    /// has more significant bits than Double's significand can represent.
    ///
    /// - Parameter value: The integer value
    /// - Returns: The floating-point value
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Conversions.intToDouble(42)  // 42.0
    /// ```
    ///
    /// Note: For very large integers (> 2^53), precision may be lost.
    @inlinable
    public static func intToDouble(_ value: Int) -> Double {
        Double(value)
    }

    /// Convert floating-point to integer - Float version
    ///
    /// Converts a Float to Int, rounding toward nearest (ties to even).
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The integer value, or nil if conversion fails
    @inlinable
    public static func floatToInt(_ value: Float) -> Int? {
        if value.isNaN || value.isInfinite {
            return nil
        }

        let minInt = Float(Int.min)
        let maxInt = Float(Int.max)
        if value < minInt || value > maxInt {
            return nil
        }

        let rounded = value.rounded(.toNearestOrEven)
        return Int(rounded)
    }

    /// Convert floating-point to integer with truncation - Float version
    ///
    /// Converts a Float to Int, rounding toward zero.
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The integer value, or nil if conversion fails
    @inlinable
    public static func floatToIntTruncating(_ value: Float) -> Int? {
        if value.isNaN || value.isInfinite {
            return nil
        }

        let minInt = Float(Int.min)
        let maxInt = Float(Int.max)
        if value < minInt || value > maxInt {
            return nil
        }

        return Int(value)
    }

    /// Convert integer to floating-point - Float version
    ///
    /// Converts an Int to Float. This conversion may round for large integers.
    ///
    /// - Parameter value: The integer value
    /// - Returns: The floating-point value
    ///
    /// Note: For integers > 2^24, precision may be lost.
    @inlinable
    public static func intToFloat(_ value: Int) -> Float {
        Float(value)
    }
}

// MARK: - Unsigned Integer Conversions

extension IEEE_754.Conversions {
    /// Convert floating-point to unsigned integer
    ///
    /// Converts a Double to UInt, rounding toward nearest (ties to even).
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The unsigned integer value, or nil if conversion fails
    @inlinable
    public static func doubleToUInt(_ value: Double) -> UInt? {
        if value.isNaN || value.isInfinite || value < 0 {
            return nil
        }

        let maxUInt = Double(UInt.max)
        if value > maxUInt {
            return nil
        }

        let rounded = value.rounded(.toNearestOrEven)
        return UInt(rounded)
    }

    /// Convert unsigned integer to floating-point
    ///
    /// Converts a UInt to Double.
    ///
    /// - Parameter value: The unsigned integer value
    /// - Returns: The floating-point value
    @inlinable
    public static func uintToDouble(_ value: UInt) -> Double {
        Double(value)
    }

    /// Convert floating-point to unsigned integer - Float version
    ///
    /// Converts a Float to UInt, rounding toward nearest (ties to even).
    ///
    /// - Parameter value: The floating-point value
    /// - Returns: The unsigned integer value, or nil if conversion fails
    @inlinable
    public static func floatToUInt(_ value: Float) -> UInt? {
        if value.isNaN || value.isInfinite || value < 0 {
            return nil
        }

        let maxUInt = Float(UInt.max)
        if value > maxUInt {
            return nil
        }

        let rounded = value.rounded(.toNearestOrEven)
        return UInt(rounded)
    }

    /// Convert unsigned integer to floating-point - Float version
    ///
    /// Converts a UInt to Float.
    ///
    /// - Parameter value: The unsigned integer value
    /// - Returns: The floating-point value
    @inlinable
    public static func uintToFloat(_ value: UInt) -> Float {
        Float(value)
    }
}
