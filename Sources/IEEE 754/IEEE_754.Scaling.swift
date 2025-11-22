// IEEE_754.Scaling.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.3: Scaling Operations
// Authoritative implementations of scaling and exponent operations

import Standards

// MARK: - IEEE 754 Scaling Operations

extension IEEE_754 {
    /// IEEE 754 scaling operations (Section 5.3)
    ///
    /// Implements the scaling and exponent operations defined in IEEE 754-2019.
    /// These operations manipulate the exponent of floating-point values.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines several scaling operations:
    /// - `scaleB` - Scale by a power of 2
    /// - `logB` - Extract the exponent
    ///
    /// These operations are fundamental for implementing various mathematical
    /// functions and for manipulating floating-point representations.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.3: Scaling operations
    /// - IEEE 754-2019 Table 5.1: Required operations
    public enum Scaling {}
}

// MARK: - Double Scaling Operations

extension IEEE_754.Scaling {
    /// Scale by power of 2 - IEEE 754 `scaleB`
    ///
    /// Returns value × 2^n. This operation is exact and efficient as it
    /// only modifies the exponent field (for normal values).
    ///
    /// - Parameters:
    ///   - value: The value to scale
    ///   - n: The power of 2 to scale by
    /// - Returns: value × 2^n
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.scaleB(3.14, 2)    // 12.56 (3.14 × 4)
    /// IEEE_754.Scaling.scaleB(3.14, -2)   // 0.785 (3.14 × 0.25)
    /// IEEE_754.Scaling.scaleB(1.0, 10)    // 1024.0
    /// ```
    ///
    /// Special cases:
    /// ```swift
    /// IEEE_754.Scaling.scaleB(.infinity, 2)  // .infinity
    /// IEEE_754.Scaling.scaleB(.nan, 2)       // .nan
    /// IEEE_754.Scaling.scaleB(0.0, 2)        // 0.0
    /// ```
    @inlinable
    public static func scaleB(_ value: Double, _ n: Int) -> Double {
        // For special values (NaN, infinity, zero), return unchanged
        if value.isNaN || value.isInfinite || value.isZero {
            return value
        }

        // Use scalbn from standard library for efficient scaling
        return value * Double(sign: .plus, exponent: n, significand: 1.0)
    }

    /// Extract exponent - IEEE 754 `logB`
    ///
    /// Returns the exponent of the value as an integer. For normal values,
    /// this is floor(log₂(|value|)).
    ///
    /// - Parameter value: The value
    /// - Returns: The exponent
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.logB(8.0)     // 3 (2^3 = 8)
    /// IEEE_754.Scaling.logB(1.5)     // 0 (in range [1, 2))
    /// IEEE_754.Scaling.logB(0.5)     // -1 (2^-1 = 0.5)
    /// IEEE_754.Scaling.logB(1024.0)  // 10 (2^10 = 1024)
    /// ```
    ///
    /// Special cases:
    /// ```swift
    /// IEEE_754.Scaling.logB(0.0)        // Int.min (or -infinity)
    /// IEEE_754.Scaling.logB(.infinity)  // Int.max (or +infinity)
    /// IEEE_754.Scaling.logB(.nan)       // Int.max (NaN propagation)
    /// ```
    @inlinable
    public static func logB(_ value: Double) -> Int {
        if value.isNaN {
            return Int.max
        }
        if value.isInfinite {
            return Int.max
        }
        if value.isZero {
            return Int.min
        }

        return value.exponent
    }

    /// Get exponent as floating-point - IEEE 754 related operation
    ///
    /// Returns the exponent of the value as a floating-point number.
    /// This is useful when the exponent might exceed Int range or when
    /// floating-point results are preferred.
    ///
    /// - Parameter value: The value
    /// - Returns: The exponent as Double
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.exponent(8.0)  // 3.0
    /// IEEE_754.Scaling.exponent(1.5)  // 0.0
    /// ```
    @inlinable
    public static func exponent(_ value: Double) -> Double {
        if value.isNaN {
            return .nan
        }
        if value.isInfinite {
            return .infinity
        }
        if value.isZero {
            return -.infinity
        }

        return Double(value.exponent)
    }

    /// Get significand (mantissa) - IEEE 754 related operation
    ///
    /// Returns the significand (mantissa) of the value, scaled to [1, 2) for
    /// normal values. Combined with exponent, this fully represents the value:
    /// value = significand × 2^exponent
    ///
    /// - Parameter value: The value
    /// - Returns: The significand
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.significand(8.0)   // 1.0 (8.0 = 1.0 × 2^3)
    /// IEEE_754.Scaling.significand(12.0)  // 1.5 (12.0 = 1.5 × 2^3)
    /// ```
    @inlinable
    public static func significand(_ value: Double) -> Double {
        value.significand
    }
}

// MARK: - Float Scaling Operations

extension IEEE_754.Scaling {
    /// Scale by power of 2 - IEEE 754 `scaleB`
    ///
    /// Returns value × 2^n. This operation is exact and efficient as it
    /// only modifies the exponent field (for normal values).
    ///
    /// - Parameters:
    ///   - value: The value to scale
    ///   - n: The power of 2 to scale by
    /// - Returns: value × 2^n
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.scaleB(Float(3.14), 2)   // 12.56
    /// IEEE_754.Scaling.scaleB(Float(1.0), 10)   // 1024.0
    /// ```
    @inlinable
    public static func scaleB(_ value: Float, _ n: Int) -> Float {
        if value.isNaN || value.isInfinite || value.isZero {
            return value
        }

        return value * Float(sign: .plus, exponent: n, significand: 1.0)
    }

    /// Extract exponent - IEEE 754 `logB`
    ///
    /// Returns the exponent of the value as an integer.
    ///
    /// - Parameter value: The value
    /// - Returns: The exponent
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Scaling.logB(Float(8.0))     // 3
    /// IEEE_754.Scaling.logB(Float(1024.0))  // 10
    /// ```
    @inlinable
    public static func logB(_ value: Float) -> Int {
        if value.isNaN {
            return Int.max
        }
        if value.isInfinite {
            return Int.max
        }
        if value.isZero {
            return Int.min
        }

        return value.exponent
    }

    /// Get exponent as floating-point
    ///
    /// Returns the exponent of the value as a floating-point number.
    ///
    /// - Parameter value: The value
    /// - Returns: The exponent as Float
    @inlinable
    public static func exponent(_ value: Float) -> Float {
        if value.isNaN {
            return .nan
        }
        if value.isInfinite {
            return .infinity
        }
        if value.isZero {
            return -.infinity
        }

        return Float(value.exponent)
    }

    /// Get significand (mantissa)
    ///
    /// Returns the significand (mantissa) of the value.
    ///
    /// - Parameter value: The value
    /// - Returns: The significand
    @inlinable
    public static func significand(_ value: Float) -> Float {
        value.significand
    }
}
