// IEEE_754.Classification.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.7: Classification Predicates
// Authoritative implementations of floating-point classification operations

import Standards

// MARK: - IEEE 754 Classification Operations

extension IEEE_754 {
    /// IEEE 754 classification operations (Section 5.7)
    ///
    /// Implements the classification predicates defined in IEEE 754-2019.
    /// These operations classify floating-point values into various categories.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines 11 classification predicates:
    /// - `isSignMinus` - Tests if sign bit is set
    /// - `isNormal` - Tests if value is normal (not zero, subnormal, infinite, or NaN)
    /// - `isFinite` - Tests if value is finite (not infinite or NaN)
    /// - `isZero` - Tests if value is zero (±0)
    /// - `isSubnormal` - Tests if value is subnormal
    /// - `isInfinite` - Tests if value is infinite (±∞)
    /// - `isNaN` - Tests if value is NaN
    /// - `isSignaling` - Tests if value is signaling NaN
    /// - `isCanonical` - Tests if representation is canonical
    /// - `class` - Returns the class of the value
    /// - `radix` - Returns the radix (always 2 for binary formats)
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.7: Details of general-computational operations
    /// - IEEE 754-2019 Table 5.2: Recommended operations
    public enum Classification {}
}

// MARK: - Double Classification Operations

extension IEEE_754.Classification {
    /// Tests if sign bit is set - IEEE 754 `isSignMinus`
    ///
    /// Returns true if the sign bit is 1, false otherwise. Note that this
    /// is true for negative zero (-0.0) and negative NaN.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if sign bit is set
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSignMinus(3.14)   // false
    /// IEEE_754.Classification.isSignMinus(-3.14)  // true
    /// IEEE_754.Classification.isSignMinus(-0.0)   // true
    /// IEEE_754.Classification.isSignMinus(0.0)    // false
    /// ```
    @inlinable
    public static func isSignMinus(_ value: Double) -> Bool {
        value.sign == .minus
    }

    /// Tests if value is normal - IEEE 754 `isNormal`
    ///
    /// Returns true if the value is normal (not zero, subnormal, infinite, or NaN).
    /// Normal numbers have a normalized significand with an implicit leading 1.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is normal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isNormal(3.14)       // true
    /// IEEE_754.Classification.isNormal(0.0)        // false
    /// IEEE_754.Classification.isNormal(.infinity)  // false
    /// IEEE_754.Classification.isNormal(.nan)       // false
    /// ```
    @inlinable
    public static func isNormal(_ value: Double) -> Bool {
        value.isNormal
    }

    /// Tests if value is finite - IEEE 754 `isFinite`
    ///
    /// Returns true if the value is finite (not infinite or NaN).
    /// This includes zero, subnormal, and normal numbers.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is finite
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isFinite(3.14)       // true
    /// IEEE_754.Classification.isFinite(0.0)        // true
    /// IEEE_754.Classification.isFinite(.infinity)  // false
    /// IEEE_754.Classification.isFinite(.nan)       // false
    /// ```
    @inlinable
    public static func isFinite(_ value: Double) -> Bool {
        value.isFinite
    }

    /// Tests if value is zero - IEEE 754 `isZero`
    ///
    /// Returns true if the value is zero. This includes both +0.0 and -0.0.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is zero
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isZero(0.0)    // true
    /// IEEE_754.Classification.isZero(-0.0)   // true
    /// IEEE_754.Classification.isZero(3.14)   // false
    /// ```
    @inlinable
    public static func isZero(_ value: Double) -> Bool {
        value.isZero
    }

    /// Tests if value is subnormal - IEEE 754 `isSubnormal`
    ///
    /// Returns true if the value is subnormal (denormalized). Subnormal numbers
    /// have an exponent of zero and a non-zero fraction, allowing representation
    /// of values smaller than the smallest normal number.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is subnormal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSubnormal(Double.leastNonzeroMagnitude)  // true
    /// IEEE_754.Classification.isSubnormal(3.14)                          // false
    /// ```
    @inlinable
    public static func isSubnormal(_ value: Double) -> Bool {
        value.isSubnormal
    }

    /// Tests if value is infinite - IEEE 754 `isInfinite`
    ///
    /// Returns true if the value is positive or negative infinity.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is infinite
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isInfinite(.infinity)   // true
    /// IEEE_754.Classification.isInfinite(-.infinity)  // true
    /// IEEE_754.Classification.isInfinite(3.14)        // false
    /// ```
    @inlinable
    public static func isInfinite(_ value: Double) -> Bool {
        value.isInfinite
    }

    /// Tests if value is NaN - IEEE 754 `isNaN`
    ///
    /// Returns true if the value is Not a Number (NaN). This includes both
    /// quiet and signaling NaN.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is NaN
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isNaN(.nan)             // true
    /// IEEE_754.Classification.isNaN(.signalingNaN)    // true
    /// IEEE_754.Classification.isNaN(3.14)             // false
    /// ```
    @inlinable
    public static func isNaN(_ value: Double) -> Bool {
        value.isNaN
    }

    /// Tests if value is signaling NaN - IEEE 754 `isSignaling`
    ///
    /// Returns true if the value is a signaling NaN. Signaling NaN should
    /// raise an exception when used in most operations.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is signaling NaN
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSignaling(.signalingNaN)  // true
    /// IEEE_754.Classification.isSignaling(.nan)           // false
    /// ```
    @inlinable
    public static func isSignaling(_ value: Double) -> Bool {
        value.isSignalingNaN
    }

    /// Tests if representation is canonical - IEEE 754 `isCanonical`
    ///
    /// Returns true if the representation is in canonical (preferred) form.
    /// For binary formats, all representations are canonical, so this always
    /// returns true. This predicate is more meaningful for decimal formats.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true (always canonical for binary formats)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isCanonical(3.14)  // true
    /// IEEE_754.Classification.isCanonical(.nan)  // true
    /// ```
    @inlinable
    public static func isCanonical(_ value: Double) -> Bool {
        value.isCanonical
    }

    /// Returns the radix - IEEE 754 `radix`
    ///
    /// Returns the radix (base) of the floating-point representation.
    /// For binary formats, this is always 2.
    ///
    /// - Parameter value: The value (unused, but maintains signature consistency)
    /// - Returns: 2 (binary radix)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.radix(3.14)  // 2
    /// ```
    @inlinable
    public static func radix(_ value: Double) -> Int {
        2
    }
}

// MARK: - Float Classification Operations

extension IEEE_754.Classification {
    /// Tests if sign bit is set - IEEE 754 `isSignMinus`
    ///
    /// Returns true if the sign bit is 1, false otherwise. Note that this
    /// is true for negative zero (-0.0) and negative NaN.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if sign bit is set
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSignMinus(Float(3.14))   // false
    /// IEEE_754.Classification.isSignMinus(Float(-3.14))  // true
    /// IEEE_754.Classification.isSignMinus(Float(-0.0))   // true
    /// ```
    @inlinable
    public static func isSignMinus(_ value: Float) -> Bool {
        value.sign == .minus
    }

    /// Tests if value is normal - IEEE 754 `isNormal`
    ///
    /// Returns true if the value is normal (not zero, subnormal, infinite, or NaN).
    /// Normal numbers have a normalized significand with an implicit leading 1.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is normal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isNormal(Float(3.14))       // true
    /// IEEE_754.Classification.isNormal(Float(0.0))        // false
    /// IEEE_754.Classification.isNormal(Float.infinity)    // false
    /// ```
    @inlinable
    public static func isNormal(_ value: Float) -> Bool {
        value.isNormal
    }

    /// Tests if value is finite - IEEE 754 `isFinite`
    ///
    /// Returns true if the value is finite (not infinite or NaN).
    /// This includes zero, subnormal, and normal numbers.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is finite
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isFinite(Float(3.14))       // true
    /// IEEE_754.Classification.isFinite(Float(0.0))        // true
    /// IEEE_754.Classification.isFinite(Float.infinity)    // false
    /// ```
    @inlinable
    public static func isFinite(_ value: Float) -> Bool {
        value.isFinite
    }

    /// Tests if value is zero - IEEE 754 `isZero`
    ///
    /// Returns true if the value is zero. This includes both +0.0 and -0.0.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is zero
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isZero(Float(0.0))    // true
    /// IEEE_754.Classification.isZero(Float(-0.0))   // true
    /// ```
    @inlinable
    public static func isZero(_ value: Float) -> Bool {
        value.isZero
    }

    /// Tests if value is subnormal - IEEE 754 `isSubnormal`
    ///
    /// Returns true if the value is subnormal (denormalized). Subnormal numbers
    /// have an exponent of zero and a non-zero fraction.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is subnormal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSubnormal(Float.leastNonzeroMagnitude)  // true
    /// IEEE_754.Classification.isSubnormal(Float(3.14))                  // false
    /// ```
    @inlinable
    public static func isSubnormal(_ value: Float) -> Bool {
        value.isSubnormal
    }

    /// Tests if value is infinite - IEEE 754 `isInfinite`
    ///
    /// Returns true if the value is positive or negative infinity.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is infinite
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isInfinite(Float.infinity)   // true
    /// IEEE_754.Classification.isInfinite(-Float.infinity)  // true
    /// ```
    @inlinable
    public static func isInfinite(_ value: Float) -> Bool {
        value.isInfinite
    }

    /// Tests if value is NaN - IEEE 754 `isNaN`
    ///
    /// Returns true if the value is Not a Number (NaN). This includes both
    /// quiet and signaling NaN.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is NaN
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isNaN(Float.nan)             // true
    /// IEEE_754.Classification.isNaN(Float.signalingNaN)    // true
    /// ```
    @inlinable
    public static func isNaN(_ value: Float) -> Bool {
        value.isNaN
    }

    /// Tests if value is signaling NaN - IEEE 754 `isSignaling`
    ///
    /// Returns true if the value is a signaling NaN. Signaling NaN should
    /// raise an exception when used in most operations.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true if value is signaling NaN
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isSignaling(Float.signalingNaN)  // true
    /// IEEE_754.Classification.isSignaling(Float.nan)           // false
    /// ```
    @inlinable
    public static func isSignaling(_ value: Float) -> Bool {
        value.isSignalingNaN
    }

    /// Tests if representation is canonical - IEEE 754 `isCanonical`
    ///
    /// Returns true if the representation is in canonical (preferred) form.
    /// For binary formats, all representations are canonical, so this always
    /// returns true.
    ///
    /// - Parameter value: The value to test
    /// - Returns: true (always canonical for binary formats)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.isCanonical(Float(3.14))  // true
    /// ```
    @inlinable
    public static func isCanonical(_ value: Float) -> Bool {
        value.isCanonical
    }

    /// Returns the radix - IEEE 754 `radix`
    ///
    /// Returns the radix (base) of the floating-point representation.
    /// For binary formats, this is always 2.
    ///
    /// - Parameter value: The value (unused, but maintains signature consistency)
    /// - Returns: 2 (binary radix)
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.radix(Float(3.14))  // 2
    /// ```
    @inlinable
    public static func radix(_ value: Float) -> Int {
        2
    }
}

// MARK: - Classification Class Enum

extension IEEE_754.Classification {
    /// IEEE 754 floating-point number classes
    ///
    /// Represents the class of a floating-point value as defined in IEEE 754-2019.
    ///
    /// ## See Also
    /// - IEEE 754-2019 Section 5.7.2: class predicate
    public enum NumberClass {
        /// Signaling NaN
        case signalingNaN
        /// Quiet NaN
        case quietNaN
        /// Negative infinity
        case negativeInfinity
        /// Negative normal number
        case negativeNormal
        /// Negative subnormal number
        case negativeSubnormal
        /// Negative zero
        case negativeZero
        /// Positive zero
        case positiveZero
        /// Positive subnormal number
        case positiveSubnormal
        /// Positive normal number
        case positiveNormal
        /// Positive infinity
        case positiveInfinity
    }

    /// Returns the class of a Double value - IEEE 754 `class`
    ///
    /// Classifies the value into one of 10 IEEE 754 number classes.
    ///
    /// - Parameter value: The value to classify
    /// - Returns: The number class
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.numberClass(3.14)       // .positiveNormal
    /// IEEE_754.Classification.numberClass(-0.0)       // .negativeZero
    /// IEEE_754.Classification.numberClass(.infinity)  // .positiveInfinity
    /// IEEE_754.Classification.numberClass(.nan)       // .quietNaN
    /// ```
    @inlinable
    public static func numberClass(_ value: Double) -> NumberClass {
        if value.isNaN {
            return value.isSignalingNaN ? .signalingNaN : .quietNaN
        }
        if value.isInfinite {
            return value.sign == .minus ? .negativeInfinity : .positiveInfinity
        }
        if value.isZero {
            return value.sign == .minus ? .negativeZero : .positiveZero
        }
        if value.isSubnormal {
            return value.sign == .minus ? .negativeSubnormal : .positiveSubnormal
        }
        return value.sign == .minus ? .negativeNormal : .positiveNormal
    }

    /// Returns the class of a Float value - IEEE 754 `class`
    ///
    /// Classifies the value into one of 10 IEEE 754 number classes.
    ///
    /// - Parameter value: The value to classify
    /// - Returns: The number class
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Classification.numberClass(Float(3.14))       // .positiveNormal
    /// IEEE_754.Classification.numberClass(Float(-0.0))       // .negativeZero
    /// IEEE_754.Classification.numberClass(Float.infinity)    // .positiveInfinity
    /// ```
    @inlinable
    public static func numberClass(_ value: Float) -> NumberClass {
        if value.isNaN {
            return value.isSignalingNaN ? .signalingNaN : .quietNaN
        }
        if value.isInfinite {
            return value.sign == .minus ? .negativeInfinity : .positiveInfinity
        }
        if value.isZero {
            return value.sign == .minus ? .negativeZero : .positiveZero
        }
        if value.isSubnormal {
            return value.sign == .minus ? .negativeSubnormal : .positiveSubnormal
        }
        return value.sign == .minus ? .negativeNormal : .positiveNormal
    }
}
