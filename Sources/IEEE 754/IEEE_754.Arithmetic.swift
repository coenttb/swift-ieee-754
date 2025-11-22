// IEEE_754.Arithmetic.swift
// swift-ieee-754
//
// IEEE 754-2019 Section 5.4: Arithmetic Operations
// Authoritative implementations for basic arithmetic operations

// MARK: - IEEE 754 Arithmetic Operations

extension IEEE_754 {
    /// IEEE 754 Arithmetic Operations (Section 5.4)
    ///
    /// Implements the required arithmetic operations defined in IEEE 754-2019.
    ///
    /// ## Overview
    ///
    /// The IEEE 754 standard requires specific arithmetic operations with defined
    /// rounding behavior and exception handling. This namespace provides named
    /// wrappers around Swift's arithmetic operators with explicit IEEE 754 semantics.
    ///
    /// ## Operations
    ///
    /// - **Basic Operations**: addition, subtraction, multiplication, division
    /// - **Special Operations**: squareRoot, fusedMultiplyAdd, remainder
    /// - **Compound Operations**: scaledProduct, ​​multiplyAdd
    ///
    /// ## Usage
    ///
    /// ```swift
    /// // Basic arithmetic
    /// let sum = IEEE_754.Arithmetic.addition(3.14, 2.72)
    /// let product = IEEE_754.Arithmetic.multiplication(2.0, 3.0)
    ///
    /// // Square root
    /// let root = IEEE_754.Arithmetic.squareRoot(2.0)
    ///
    /// // Fused multiply-add (exact intermediate result)
    /// let fma = IEEE_754.Arithmetic.fusedMultiplyAdd(a: 2.0, b: 3.0, c: 1.0)  // (2*3)+1
    /// ```
    ///
    /// ## Rounding
    ///
    /// All operations follow IEEE 754 rounding modes. Swift's default rounding is
    /// roundTiesToEven (banker's rounding). For other rounding modes, see ``Rounding``.
    ///
    /// ## Exceptions
    ///
    /// These operations may raise IEEE 754 exceptions (invalid, overflow, underflow,
    /// division by zero, inexact). See ``Exceptions`` for exception handling.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.4: Arithmetic operations
    /// - IEEE 754-2019 Section 5.4.1: Arithmetic operations (general)
    /// - IEEE 754-2019 Section 5.4.2: Minimum and maximum operations
    public enum Arithmetic {}
}

// MARK: - Basic Arithmetic Operations

extension IEEE_754.Arithmetic {
    /// Addition - IEEE 754 addition operation
    ///
    /// Adds two floating-point values according to IEEE 754-2019 Section 5.4.1.
    ///
    /// - Parameters:
    ///   - lhs: Left operand
    ///   - rhs: Right operand
    /// - Returns: Sum of lhs and rhs
    ///
    /// Example:
    /// ```swift
    /// let sum = IEEE_754.Arithmetic.addition(3.14, 2.72)  // 5.86
    /// ```
    ///
    /// Special cases:
    /// - ±∞ + ±∞ → ±∞ (same sign)
    /// - ∞ + (-∞) → NaN (raises invalid exception)
    /// - NaN + x → NaN
    /// - ±0 + ±0 → +0 (unless both are -0)
    @inlinable
    public static func addition<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
        lhs + rhs
    }

    /// Subtraction - IEEE 754 subtraction operation
    ///
    /// Subtracts one floating-point value from another.
    ///
    /// - Parameters:
    ///   - lhs: Left operand (minuend)
    ///   - rhs: Right operand (subtrahend)
    /// - Returns: Difference lhs - rhs
    ///
    /// Example:
    /// ```swift
    /// let diff = IEEE_754.Arithmetic.subtraction(5.0, 3.0)  // 2.0
    /// ```
    @inlinable
    public static func subtraction<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
        lhs - rhs
    }

    /// Multiplication - IEEE 754 multiplication operation
    ///
    /// Multiplies two floating-point values.
    ///
    /// - Parameters:
    ///   - lhs: Left operand
    ///   - rhs: Right operand
    /// - Returns: Product of lhs and rhs
    ///
    /// Example:
    /// ```swift
    /// let product = IEEE_754.Arithmetic.multiplication(3.0, 4.0)  // 12.0
    /// ```
    ///
    /// Special cases:
    /// - ±∞ * ±∞ → ±∞
    /// - ±∞ * 0 → NaN (raises invalid exception)
    /// - NaN * x → NaN
    @inlinable
    public static func multiplication<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
        lhs * rhs
    }

    /// Division - IEEE 754 division operation
    ///
    /// Divides one floating-point value by another.
    ///
    /// - Parameters:
    ///   - lhs: Dividend
    ///   - rhs: Divisor
    /// - Returns: Quotient lhs / rhs
    ///
    /// Example:
    /// ```swift
    /// let quotient = IEEE_754.Arithmetic.division(10.0, 2.0)  // 5.0
    /// ```
    ///
    /// Special cases:
    /// - x / 0 → ±∞ (raises division by zero exception) where x ≠ 0
    /// - 0 / 0 → NaN (raises invalid exception)
    /// - ±∞ / ±∞ → NaN (raises invalid exception)
    /// - NaN / x → NaN
    @inlinable
    public static func division<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
        lhs / rhs
    }

    /// Remainder - IEEE 754 remainder operation
    ///
    /// Computes the IEEE 754 remainder of division.
    ///
    /// - Parameters:
    ///   - lhs: Dividend
    ///   - rhs: Divisor
    /// - Returns: Remainder of lhs / rhs
    ///
    /// Example:
    /// ```swift
    /// let rem = IEEE_754.Arithmetic.remainder(7.0, 3.0)  // 1.0
    /// ```
    ///
    /// Note: This implements IEEE 754 remainder, which may differ from truncated
    /// remainder (%) in Swift.
    @inlinable
    public static func remainder<T: BinaryFloatingPoint>(_ lhs: T, _ rhs: T) -> T {
        lhs.remainder(dividingBy: rhs)
    }
}

// MARK: - Special Arithmetic Operations

extension IEEE_754.Arithmetic {
    /// Square Root - IEEE 754 square root operation
    ///
    /// Computes the square root of a floating-point value.
    ///
    /// - Parameter value: The value
    /// - Returns: Square root of value
    ///
    /// Example:
    /// ```swift
    /// let root = IEEE_754.Arithmetic.squareRoot(4.0)  // 2.0
    /// let root2 = IEEE_754.Arithmetic.squareRoot(2.0)  // 1.4142135623730951
    /// ```
    ///
    /// Special cases:
    /// - √(-x) → NaN for x > 0 (raises invalid exception)
    /// - √(+∞) → +∞
    /// - √(NaN) → NaN
    /// - √(±0) → ±0
    @inlinable
    public static func squareRoot<T: BinaryFloatingPoint>(_ value: T) -> T {
        value.squareRoot()
    }

    /// Fused Multiply-Add - IEEE 754 fusedMultiplyAdd operation
    ///
    /// Computes (a × b) + c with a single rounding operation.
    ///
    /// - Parameters:
    ///   - a: First multiplicand
    ///   - b: Second multiplicand
    ///   - c: Addend
    /// - Returns: (a × b) + c, rounded once
    ///
    /// Example:
    /// ```swift
    /// let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: 2.0, b: 3.0, c: 1.0)
    /// // Result: 7.0 = (2.0 * 3.0) + 1.0
    /// ```
    ///
    /// ## Accuracy
    ///
    /// This operation is more accurate than separate multiply and add because
    /// the intermediate product is computed exactly (no rounding) before adding c.
    ///
    /// ## See Also
    ///
    /// - IEEE 754-2019 Section 5.4.1: FusedMultiplyAdd operation
    @inlinable
    public static func fusedMultiplyAdd<T: BinaryFloatingPoint>(a: T, b: T, c: T) -> T {
        c.addingProduct(a, b)  // Computes c + (a × b) = (a × b) + c
    }
}

// MARK: - Compound Operations

extension IEEE_754.Arithmetic {
    /// Absolute Value - IEEE 754 abs operation
    ///
    /// Returns the absolute value of a floating-point number.
    ///
    /// - Parameter value: The value
    /// - Returns: |value|
    ///
    /// Example:
    /// ```swift
    /// let abs1 = IEEE_754.Arithmetic.absoluteValue(-3.14)  // 3.14
    /// let abs2 = IEEE_754.Arithmetic.absoluteValue(2.72)   // 2.72
    /// ```
    ///
    /// Special cases:
    /// - abs(±∞) → +∞
    /// - abs(NaN) → NaN (payload preserved)
    /// - abs(±0) → +0
    @inlinable
    public static func absoluteValue<T: BinaryFloatingPoint>(_ value: T) -> T {
        abs(value)
    }

    /// Negate - IEEE 754 negate operation
    ///
    /// Returns the negation of a floating-point number.
    ///
    /// - Parameter value: The value
    /// - Returns: -value
    ///
    /// Example:
    /// ```swift
    /// let neg1 = IEEE_754.Arithmetic.negate(3.14)   // -3.14
    /// let neg2 = IEEE_754.Arithmetic.negate(-2.72)  // 2.72
    /// ```
    ///
    /// Special cases:
    /// - negate(±∞) → ∓∞
    /// - negate(NaN) → NaN (payload and sign preserved)
    /// - negate(±0) → ∓0
    @inlinable
    public static func negate<T: BinaryFloatingPoint>(_ value: T) -> T {
        -value
    }
}

