// IEEE_754+Rounding.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.9-5.10: Round to Integral Operations

import Standards

// MARK: - IEEE 754 Rounding Operations

extension IEEE_754 {
    /// IEEE 754 rounding operations (Section 5.9-5.10)
    ///
    /// Implements the roundToIntegral operations defined in IEEE 754-2019.
    /// These operations round floating-point values to integral values while
    /// maintaining the floating-point type.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines specific rounding operations:
    /// - `roundToIntegralTowardNegative` (floor)
    /// - `roundToIntegralTowardPositive` (ceil)
    /// - `roundToIntegralTiesToEven` (round)
    /// - `roundToIntegralTowardZero` (trunc)
    ///
    /// ## Special Values
    ///
    /// All operations correctly handle IEEE 754 special values:
    /// - ±0.0 → ±0.0
    /// - ±Infinity → ±Infinity
    /// - NaN → NaN (with payload preserved)
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.9: Details of operations to round a floating-point datum to integral value
    /// - IEEE 754-2019 Section 5.10: Details of totalOrder predicate
    public enum Rounding {}
}

// MARK: - Double Rounding Operations

extension IEEE_754.Rounding {
    /// Rounds toward negative infinity (floor)
    ///
    /// Returns the largest integral value less than or equal to the input.
    /// Implements IEEE 754 `roundToIntegralTowardNegative`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The largest integral value ≤ value
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.floor(3.7)   // 3.0
    /// IEEE_754.Rounding.floor(-3.7)  // -4.0
    /// IEEE_754.Rounding.floor(3.0)   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.floor(.infinity)  // .infinity
    /// IEEE_754.Rounding.floor(-.infinity) // -.infinity
    /// IEEE_754.Rounding.floor(.nan)       // .nan
    /// ```
    @inlinable
    public static func floor(_ value: Double) -> Double {
        value.rounded(.down)
    }

    /// Rounds toward positive infinity (ceil)
    ///
    /// Returns the smallest integral value greater than or equal to the input.
    /// Implements IEEE 754 `roundToIntegralTowardPositive`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The smallest integral value ≥ value
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.ceil(3.2)   // 4.0
    /// IEEE_754.Rounding.ceil(-3.2)  // -3.0
    /// IEEE_754.Rounding.ceil(3.0)   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.ceil(.infinity)  // .infinity
    /// IEEE_754.Rounding.ceil(-.infinity) // -.infinity
    /// IEEE_754.Rounding.ceil(.nan)       // .nan
    /// ```
    @inlinable
    public static func ceil(_ value: Double) -> Double {
        value.rounded(.up)
    }

    /// Rounds to nearest integral value, ties to even (round)
    ///
    /// Returns the nearest integral value. When exactly halfway between two integers,
    /// rounds to the even value. Implements IEEE 754 `roundToIntegralTiesToEven`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The nearest integral value (ties to even)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.round(3.4)   // 3.0
    /// IEEE_754.Rounding.round(3.5)   // 4.0 (ties to even)
    /// IEEE_754.Rounding.round(3.6)   // 4.0
    /// IEEE_754.Rounding.round(4.5)   // 4.0 (ties to even)
    /// IEEE_754.Rounding.round(-3.5)  // -4.0 (ties to even)
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.round(.infinity)  // .infinity
    /// IEEE_754.Rounding.round(-.infinity) // -.infinity
    /// IEEE_754.Rounding.round(.nan)       // .nan
    /// ```
    @inlinable
    public static func round(_ value: Double) -> Double {
        value.rounded(.toNearestOrEven)
    }

    /// Rounds toward zero (trunc)
    ///
    /// Returns the integral value closest to zero. Implements IEEE 754
    /// `roundToIntegralTowardZero`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The integral value closest to zero
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.trunc(3.7)   // 3.0
    /// IEEE_754.Rounding.trunc(-3.7)  // -3.0
    /// IEEE_754.Rounding.trunc(3.0)   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.trunc(.infinity)  // .infinity
    /// IEEE_754.Rounding.trunc(-.infinity) // -.infinity
    /// IEEE_754.Rounding.trunc(.nan)       // .nan
    /// ```
    @inlinable
    public static func trunc(_ value: Double) -> Double {
        value.rounded(.towardZero)
    }
}

// MARK: - Float Rounding Operations

extension IEEE_754.Rounding {
    /// Rounds toward negative infinity (floor)
    ///
    /// Returns the largest integral value less than or equal to the input.
    /// Implements IEEE 754 `roundToIntegralTowardNegative`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The largest integral value ≤ value
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.floor(Float(3.7))   // 3.0
    /// IEEE_754.Rounding.floor(Float(-3.7))  // -4.0
    /// IEEE_754.Rounding.floor(Float(3.0))   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.floor(Float.infinity)  // .infinity
    /// IEEE_754.Rounding.floor(-Float.infinity) // -.infinity
    /// IEEE_754.Rounding.floor(Float.nan)       // .nan
    /// ```
    @inlinable
    public static func floor(_ value: Float) -> Float {
        value.rounded(.down)
    }

    /// Rounds toward positive infinity (ceil)
    ///
    /// Returns the smallest integral value greater than or equal to the input.
    /// Implements IEEE 754 `roundToIntegralTowardPositive`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The smallest integral value ≥ value
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.ceil(Float(3.2))   // 4.0
    /// IEEE_754.Rounding.ceil(Float(-3.2))  // -3.0
    /// IEEE_754.Rounding.ceil(Float(3.0))   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.ceil(Float.infinity)  // .infinity
    /// IEEE_754.Rounding.ceil(-Float.infinity) // -.infinity
    /// IEEE_754.Rounding.ceil(Float.nan)       // .nan
    /// ```
    @inlinable
    public static func ceil(_ value: Float) -> Float {
        value.rounded(.up)
    }

    /// Rounds to nearest integral value, ties to even (round)
    ///
    /// Returns the nearest integral value. When exactly halfway between two integers,
    /// rounds to the even value. Implements IEEE 754 `roundToIntegralTiesToEven`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The nearest integral value (ties to even)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.round(Float(3.4))   // 3.0
    /// IEEE_754.Rounding.round(Float(3.5))   // 4.0 (ties to even)
    /// IEEE_754.Rounding.round(Float(3.6))   // 4.0
    /// IEEE_754.Rounding.round(Float(4.5))   // 4.0 (ties to even)
    /// IEEE_754.Rounding.round(Float(-3.5))  // -4.0 (ties to even)
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.round(Float.infinity)  // .infinity
    /// IEEE_754.Rounding.round(-Float.infinity) // -.infinity
    /// IEEE_754.Rounding.round(Float.nan)       // .nan
    /// ```
    @inlinable
    public static func round(_ value: Float) -> Float {
        value.rounded(.toNearestOrEven)
    }

    /// Rounds toward zero (trunc)
    ///
    /// Returns the integral value closest to zero. Implements IEEE 754
    /// `roundToIntegralTowardZero`.
    ///
    /// - Parameter value: The value to round
    /// - Returns: The integral value closest to zero
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Rounding.trunc(Float(3.7))   // 3.0
    /// IEEE_754.Rounding.trunc(Float(-3.7))  // -3.0
    /// IEEE_754.Rounding.trunc(Float(3.0))   // 3.0
    /// ```
    ///
    /// Special values:
    /// ```swift
    /// IEEE_754.Rounding.trunc(Float.infinity)  // .infinity
    /// IEEE_754.Rounding.trunc(-Float.infinity) // -.infinity
    /// IEEE_754.Rounding.trunc(Float.nan)       // .nan
    /// ```
    @inlinable
    public static func trunc(_ value: Float) -> Float {
        value.rounded(.towardZero)
    }
}

// MARK: - Namespaced Convenience Extensions

extension Double.IEEE754 {
    /// IEEE 754 floor operation
    ///
    /// Rounds toward negative infinity.
    public var floor: Double {
        IEEE_754.Rounding.floor(double)
    }

    /// IEEE 754 ceil operation
    ///
    /// Rounds toward positive infinity.
    public var ceil: Double {
        IEEE_754.Rounding.ceil(double)
    }

    /// IEEE 754 round operation
    ///
    /// Rounds to nearest integral value (ties to even).
    public var round: Double {
        IEEE_754.Rounding.round(double)
    }

    /// IEEE 754 trunc operation
    ///
    /// Rounds toward zero.
    public var trunc: Double {
        IEEE_754.Rounding.trunc(double)
    }
}

extension Float.IEEE754 {
    /// IEEE 754 floor operation
    ///
    /// Rounds toward negative infinity.
    public var floor: Float {
        IEEE_754.Rounding.floor(float)
    }

    /// IEEE 754 ceil operation
    ///
    /// Rounds toward positive infinity.
    public var ceil: Float {
        IEEE_754.Rounding.ceil(float)
    }

    /// IEEE 754 round operation
    ///
    /// Rounds to nearest integral value (ties to even).
    public var round: Float {
        IEEE_754.Rounding.round(float)
    }

    /// IEEE 754 trunc operation
    ///
    /// Rounds toward zero.
    public var trunc: Float {
        IEEE_754.Rounding.trunc(float)
    }
}
