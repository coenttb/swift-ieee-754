// IEEE_754.Comparison.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.6: Comparison Predicates
// Authoritative implementations of floating-point comparison operations

import Standards

// MARK: - IEEE 754 Comparison Operations

extension IEEE_754 {
    /// IEEE 754 comparison operations (Section 5.6 & 5.10)
    ///
    /// Implements the comparison predicates defined in IEEE 754-2019.
    /// These operations compare floating-point values according to IEEE 754 rules.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard defines several comparison predicates:
    ///
    /// ### Standard Comparisons (Section 5.6)
    /// - `compareQuietEqual` - Quiet equality (NaN returns false)
    /// - `compareQuietNotEqual` - Quiet inequality
    /// - `compareQuietLess` - Quiet less than
    /// - `compareQuietLessEqual` - Quiet less than or equal
    /// - `compareQuietGreater` - Quiet greater than
    /// - `compareQuietGreaterEqual` - Quiet greater than or equal
    ///
    /// ### Signaling Comparisons
    /// - Signaling comparisons raise exceptions on NaN inputs
    ///
    /// ### Total Order (Section 5.10)
    /// - `totalOrder` - Total ordering including NaN values
    /// - `totalOrderMag` - Total ordering by magnitude
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.6: Details of comparison predicates
    /// - IEEE 754-2019 Section 5.10: Details of totalOrder predicate
    public enum Comparison {}
}

// MARK: - Double Comparison Operations

extension IEEE_754.Comparison {
    /// Quiet equality comparison - IEEE 754 `compareQuietEqual`
    ///
    /// Returns true if values are equal. Returns false if either value is NaN.
    /// Treats +0.0 and -0.0 as equal.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if values are equal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isEqual(3.14, 3.14)    // true
    /// IEEE_754.Comparison.isEqual(0.0, -0.0)     // true
    /// IEEE_754.Comparison.isEqual(.nan, .nan)    // false
    /// IEEE_754.Comparison.isEqual(3.14, 2.71)    // false
    /// ```
    @inlinable
    public static func isEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs == rhs
    }

    /// Quiet inequality comparison - IEEE 754 `compareQuietNotEqual`
    ///
    /// Returns true if values are not equal. Returns true if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if values are not equal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isNotEqual(3.14, 2.71)  // true
    /// IEEE_754.Comparison.isNotEqual(.nan, 3.14)  // true
    /// IEEE_754.Comparison.isNotEqual(3.14, 3.14)  // false
    /// ```
    @inlinable
    public static func isNotEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs != rhs
    }

    /// Quiet less than comparison - IEEE 754 `compareQuietLess`
    ///
    /// Returns true if lhs < rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs < rhs
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isLess(2.71, 3.14)   // true
    /// IEEE_754.Comparison.isLess(3.14, 2.71)   // false
    /// IEEE_754.Comparison.isLess(.nan, 3.14)   // false
    /// ```
    @inlinable
    public static func isLess(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs < rhs
    }

    /// Quiet less than or equal comparison - IEEE 754 `compareQuietLessEqual`
    ///
    /// Returns true if lhs <= rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs <= rhs
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isLessEqual(2.71, 3.14)  // true
    /// IEEE_754.Comparison.isLessEqual(3.14, 3.14)  // true
    /// IEEE_754.Comparison.isLessEqual(3.14, 2.71)  // false
    /// ```
    @inlinable
    public static func isLessEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs <= rhs
    }

    /// Quiet greater than comparison - IEEE 754 `compareQuietGreater`
    ///
    /// Returns true if lhs > rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs > rhs
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isGreater(3.14, 2.71)  // true
    /// IEEE_754.Comparison.isGreater(2.71, 3.14)  // false
    /// ```
    @inlinable
    public static func isGreater(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs > rhs
    }

    /// Quiet greater than or equal comparison - IEEE 754 `compareQuietGreaterEqual`
    ///
    /// Returns true if lhs >= rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs >= rhs
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isGreaterEqual(3.14, 2.71)  // true
    /// IEEE_754.Comparison.isGreaterEqual(3.14, 3.14)  // true
    /// IEEE_754.Comparison.isGreaterEqual(2.71, 3.14)  // false
    /// ```
    @inlinable
    public static func isGreaterEqual(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs >= rhs
    }

    /// Total order predicate - IEEE 754 `totalOrder`
    ///
    /// Implements the totalOrder predicate that defines a total ordering over
    /// all floating-point values, including NaN and signed zeros.
    ///
    /// The ordering is:
    /// - -NaN < -Infinity < -Finite < -0.0 < +0.0 < +Finite < +Infinity < +NaN
    /// - NaN values are ordered by their payload
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs is ordered before rhs in total order
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.totalOrder(-0.0, 0.0)        // true (-0 < +0)
    /// IEEE_754.Comparison.totalOrder(.nan, 3.14)       // false (NaN is largest)
    /// IEEE_754.Comparison.totalOrder(-.infinity, 0.0)  // true
    /// ```
    @inlinable
    public static func totalOrder(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs.isTotallyOrdered(belowOrEqualTo: rhs)
    }

    /// Total order magnitude predicate - IEEE 754 `totalOrderMag`
    ///
    /// Like totalOrder, but compares absolute values. Implements a total
    /// ordering based on magnitude.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if |lhs| is ordered before |rhs| in total order
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.totalOrderMag(-3.14, 2.71)  // false (3.14 > 2.71)
    /// IEEE_754.Comparison.totalOrderMag(2.71, -3.14)  // true (2.71 < 3.14)
    /// ```
    @inlinable
    public static func totalOrderMag(_ lhs: Double, _ rhs: Double) -> Bool {
        lhs.magnitude.isTotallyOrdered(belowOrEqualTo: rhs.magnitude)
    }
}

// MARK: - Float Comparison Operations

extension IEEE_754.Comparison {
    /// Quiet equality comparison - IEEE 754 `compareQuietEqual`
    ///
    /// Returns true if values are equal. Returns false if either value is NaN.
    /// Treats +0.0 and -0.0 as equal.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if values are equal
    ///
    /// Example:
    /// ```swift
    /// IEEE_754.Comparison.isEqual(Float(3.14), Float(3.14))  // true
    /// IEEE_754.Comparison.isEqual(Float(0.0), Float(-0.0))   // true
    /// IEEE_754.Comparison.isEqual(Float.nan, Float.nan)      // false
    /// ```
    @inlinable
    public static func isEqual(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs == rhs
    }

    /// Quiet inequality comparison - IEEE 754 `compareQuietNotEqual`
    ///
    /// Returns true if values are not equal. Returns true if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if values are not equal
    @inlinable
    public static func isNotEqual(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs != rhs
    }

    /// Quiet less than comparison - IEEE 754 `compareQuietLess`
    ///
    /// Returns true if lhs < rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs < rhs
    @inlinable
    public static func isLess(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs < rhs
    }

    /// Quiet less than or equal comparison - IEEE 754 `compareQuietLessEqual`
    ///
    /// Returns true if lhs <= rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs <= rhs
    @inlinable
    public static func isLessEqual(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs <= rhs
    }

    /// Quiet greater than comparison - IEEE 754 `compareQuietGreater`
    ///
    /// Returns true if lhs > rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs > rhs
    @inlinable
    public static func isGreater(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs > rhs
    }

    /// Quiet greater than or equal comparison - IEEE 754 `compareQuietGreaterEqual`
    ///
    /// Returns true if lhs >= rhs. Returns false if either value is NaN.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs >= rhs
    @inlinable
    public static func isGreaterEqual(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs >= rhs
    }

    /// Total order predicate - IEEE 754 `totalOrder`
    ///
    /// Implements the totalOrder predicate that defines a total ordering over
    /// all floating-point values, including NaN and signed zeros.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if lhs is ordered before rhs in total order
    @inlinable
    public static func totalOrder(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs.isTotallyOrdered(belowOrEqualTo: rhs)
    }

    /// Total order magnitude predicate - IEEE 754 `totalOrderMag`
    ///
    /// Like totalOrder, but compares absolute values. Implements a total
    /// ordering based on magnitude.
    ///
    /// - Parameters:
    ///   - lhs: Left-hand value
    ///   - rhs: Right-hand value
    /// - Returns: true if |lhs| is ordered before |rhs| in total order
    @inlinable
    public static func totalOrderMag(_ lhs: Float, _ rhs: Float) -> Bool {
        lhs.magnitude.isTotallyOrdered(belowOrEqualTo: rhs.magnitude)
    }
}
