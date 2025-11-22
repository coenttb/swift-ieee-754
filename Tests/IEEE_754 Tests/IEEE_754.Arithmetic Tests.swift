// IEEE_754.Arithmetic Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.4 Arithmetic Operations

import Testing

@testable import IEEE_754

// MARK: - Basic Arithmetic Operations Tests

@Suite("IEEE_754.Arithmetic - Addition")
struct ArithmeticAdditionTests {
    @Test func basicAddition() {
        let result = IEEE_754.Arithmetic.addition(3.14, 2.86)
        #expect(result == 6.0)
    }

    @Test func negativeAddition() {
        let result = IEEE_754.Arithmetic.addition(-5.0, 3.0)
        #expect(result == -2.0)
    }

    @Test func zeroAddition() {
        #expect(IEEE_754.Arithmetic.addition(0.0, 0.0) == 0.0)
        #expect(IEEE_754.Arithmetic.addition(5.0, 0.0) == 5.0)
        #expect(IEEE_754.Arithmetic.addition(-0.0, 0.0) == 0.0)
    }

    @Test func infinityAddition() {
        #expect(IEEE_754.Arithmetic.addition(Double.infinity, 5.0) == Double.infinity)
        #expect(IEEE_754.Arithmetic.addition(-Double.infinity, 5.0) == -Double.infinity)
        #expect(IEEE_754.Arithmetic.addition(Double.infinity, Double.infinity) == Double.infinity)
    }

    @Test func nanAddition() {
        let result = IEEE_754.Arithmetic.addition(Double.infinity, -Double.infinity)
        #expect(result.isNaN)
    }

    @Test func floatAddition() {
        let result = IEEE_754.Arithmetic.addition(Float(1.5), Float(2.5))
        #expect(result == 4.0)
    }
}

@Suite("IEEE_754.Arithmetic - Subtraction")
struct ArithmeticSubtractionTests {
    @Test func basicSubtraction() {
        let result = IEEE_754.Arithmetic.subtraction(10.0, 3.0)
        #expect(result == 7.0)
    }

    @Test func negativeSubtraction() {
        let result = IEEE_754.Arithmetic.subtraction(-5.0, -3.0)
        #expect(result == -2.0)
    }

    @Test func zeroSubtraction() {
        #expect(IEEE_754.Arithmetic.subtraction(5.0, 5.0) == 0.0)
        #expect(IEEE_754.Arithmetic.subtraction(0.0, 0.0) == 0.0)
    }

    @Test func infinitySubtraction() {
        #expect(IEEE_754.Arithmetic.subtraction(Double.infinity, 5.0) == Double.infinity)
        let result = IEEE_754.Arithmetic.subtraction(Double.infinity, Double.infinity)
        #expect(result.isNaN)
    }
}

@Suite("IEEE_754.Arithmetic - Multiplication")
struct ArithmeticMultiplicationTests {
    @Test func basicMultiplication() {
        let result = IEEE_754.Arithmetic.multiplication(3.0, 4.0)
        #expect(result == 12.0)
    }

    @Test func negativeMultiplication() {
        #expect(IEEE_754.Arithmetic.multiplication(-3.0, 4.0) == -12.0)
        #expect(IEEE_754.Arithmetic.multiplication(-3.0, -4.0) == 12.0)
    }

    @Test func zeroMultiplication() {
        #expect(IEEE_754.Arithmetic.multiplication(0.0, 5.0) == 0.0)
        #expect(IEEE_754.Arithmetic.multiplication(5.0, 0.0) == 0.0)
    }

    @Test func infinityMultiplication() {
        #expect(IEEE_754.Arithmetic.multiplication(Double.infinity, 2.0) == Double.infinity)
        #expect(IEEE_754.Arithmetic.multiplication(Double.infinity, -2.0) == -Double.infinity)

        let result = IEEE_754.Arithmetic.multiplication(Double.infinity, 0.0)
        #expect(result.isNaN)
    }

    @Test func subnormalMultiplication() {
        let tiny = Double.leastNonzeroMagnitude
        let result = IEEE_754.Arithmetic.multiplication(tiny, 0.5)
        #expect(result == 0.0 || result == tiny * 0.5)
    }
}

@Suite("IEEE_754.Arithmetic - Division")
struct ArithmeticDivisionTests {
    @Test func basicDivision() {
        let result = IEEE_754.Arithmetic.division(10.0, 2.0)
        #expect(result == 5.0)
    }

    @Test func negativeDivision() {
        #expect(IEEE_754.Arithmetic.division(-10.0, 2.0) == -5.0)
        #expect(IEEE_754.Arithmetic.division(10.0, -2.0) == -5.0)
        #expect(IEEE_754.Arithmetic.division(-10.0, -2.0) == 5.0)
    }

    @Test func divisionByZero() {
        #expect(IEEE_754.Arithmetic.division(5.0, 0.0) == Double.infinity)
        #expect(IEEE_754.Arithmetic.division(-5.0, 0.0) == -Double.infinity)

        let result = IEEE_754.Arithmetic.division(0.0, 0.0)
        #expect(result.isNaN)
    }

    @Test func infinityDivision() {
        #expect(IEEE_754.Arithmetic.division(5.0, Double.infinity) == 0.0)

        let result = IEEE_754.Arithmetic.division(Double.infinity, Double.infinity)
        #expect(result.isNaN)
    }

    @Test func exactDivision() {
        #expect(IEEE_754.Arithmetic.division(1.0, 2.0) == 0.5)
        #expect(IEEE_754.Arithmetic.division(1.0, 4.0) == 0.25)
    }
}

@Suite("IEEE_754.Arithmetic - Remainder")
struct ArithmeticRemainderTests {
    @Test func basicRemainder() {
        let result = IEEE_754.Arithmetic.remainder(7.0, 3.0)
        #expect(result == 1.0)
    }

    @Test func exactRemainder() {
        let result = IEEE_754.Arithmetic.remainder(10.0, 5.0)
        #expect(result == 0.0)
    }

    @Test func negativeRemainder() {
        let result1 = IEEE_754.Arithmetic.remainder(-7.0, 3.0)
        let result2 = IEEE_754.Arithmetic.remainder(7.0, -3.0)
        #expect(result1 == -1.0)
        #expect(result2 == 1.0)
    }

    @Test func fractionalRemainder() {
        // IEEE 754 remainder: 7.5 / 2.0 → quotient rounds to 4 (nearest even)
        // remainder = 7.5 - (4 × 2.0) = -0.5
        let result = IEEE_754.Arithmetic.remainder(7.5, 2.0)
        #expect(abs(result - (-0.5)) < 0.0001)
    }
}

// MARK: - Special Operations Tests

@Suite("IEEE_754.Arithmetic - Square Root")
struct ArithmeticSquareRootTests {
    @Test func perfectSquares() {
        #expect(IEEE_754.Arithmetic.squareRoot(4.0) == 2.0)
        #expect(IEEE_754.Arithmetic.squareRoot(9.0) == 3.0)
        #expect(IEEE_754.Arithmetic.squareRoot(16.0) == 4.0)
        #expect(IEEE_754.Arithmetic.squareRoot(1.0) == 1.0)
        #expect(IEEE_754.Arithmetic.squareRoot(0.0) == 0.0)
    }

    @Test func imperfectSquares() {
        let sqrt2 = IEEE_754.Arithmetic.squareRoot(2.0)
        #expect(abs(sqrt2 - 1.4142135623730951) < 1e-15)
    }

    @Test func negativeSquareRoot() {
        let result = IEEE_754.Arithmetic.squareRoot(-1.0)
        #expect(result.isNaN)
    }

    @Test func infinitySquareRoot() {
        #expect(IEEE_754.Arithmetic.squareRoot(Double.infinity) == Double.infinity)
    }

    @Test func subnormalSquareRoot() {
        let tiny = Double.leastNonzeroMagnitude
        let result = IEEE_754.Arithmetic.squareRoot(tiny)
        #expect(result > 0)
    }

    @Test func floatSquareRoot() {
        let result = IEEE_754.Arithmetic.squareRoot(Float(4.0))
        #expect(result == 2.0)
    }
}

@Suite("IEEE_754.Arithmetic - Fused Multiply-Add")
struct ArithmeticFMATests {
    @Test func basicFMA() {
        // (2 * 3) + 1 = 7
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: 2.0, b: 3.0, c: 1.0)
        #expect(result == 7.0)
    }

    @Test func zeroFMA() {
        // (0 * 5) + 3 = 3
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: 0.0, b: 5.0, c: 3.0)
        #expect(result == 3.0)
    }

    @Test func negativeFMA() {
        // (-2 * 3) + 10 = 4
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: -2.0, b: 3.0, c: 10.0)
        #expect(result == 4.0)
    }

    @Test func fmaAccuracy() {
        // FMA should be more accurate than separate multiply and add
        // Test case where intermediate overflow would occur
        let huge = Double.greatestFiniteMagnitude / 2.0
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: huge, b: 2.0, c: -huge)
        #expect(result.isFinite || result == huge)
    }

    @Test func fmaWithInfinity() {
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: Double.infinity, b: 2.0, c: 3.0)
        #expect(result == Double.infinity)
    }

    @Test func floatFMA() {
        let result = IEEE_754.Arithmetic.fusedMultiplyAdd(a: Float(2.0), b: Float(3.0), c: Float(1.0))
        #expect(result == 7.0)
    }
}

// MARK: - Compound Operations Tests

@Suite("IEEE_754.Arithmetic - Absolute Value")
struct ArithmeticAbsoluteValueTests {
    @Test func positiveAbs() {
        #expect(IEEE_754.Arithmetic.absoluteValue(5.0) == 5.0)
        #expect(IEEE_754.Arithmetic.absoluteValue(3.14) == 3.14)
    }

    @Test func negativeAbs() {
        #expect(IEEE_754.Arithmetic.absoluteValue(-5.0) == 5.0)
        #expect(IEEE_754.Arithmetic.absoluteValue(-3.14) == 3.14)
    }

    @Test func zeroAbs() {
        #expect(IEEE_754.Arithmetic.absoluteValue(0.0) == 0.0)
        #expect(IEEE_754.Arithmetic.absoluteValue(-0.0) == 0.0)
    }

    @Test func infinityAbs() {
        #expect(IEEE_754.Arithmetic.absoluteValue(Double.infinity) == Double.infinity)
        #expect(IEEE_754.Arithmetic.absoluteValue(-Double.infinity) == Double.infinity)
    }

    @Test func nanAbs() {
        let result = IEEE_754.Arithmetic.absoluteValue(Double.nan)
        #expect(result.isNaN)
    }

    @Test func subnormalAbs() {
        let tiny = -Double.leastNonzeroMagnitude
        #expect(IEEE_754.Arithmetic.absoluteValue(tiny) == Double.leastNonzeroMagnitude)
    }
}

@Suite("IEEE_754.Arithmetic - Negate")
struct ArithmeticNegateTests {
    @Test func positiveNegate() {
        #expect(IEEE_754.Arithmetic.negate(5.0) == -5.0)
        #expect(IEEE_754.Arithmetic.negate(3.14) == -3.14)
    }

    @Test func negativeNegate() {
        #expect(IEEE_754.Arithmetic.negate(-5.0) == 5.0)
        #expect(IEEE_754.Arithmetic.negate(-3.14) == 3.14)
    }

    @Test func zeroNegate() {
        #expect(IEEE_754.Arithmetic.negate(0.0) == -0.0)
        #expect(IEEE_754.Arithmetic.negate(-0.0) == 0.0)
    }

    @Test func infinityNegate() {
        #expect(IEEE_754.Arithmetic.negate(Double.infinity) == -Double.infinity)
        #expect(IEEE_754.Arithmetic.negate(-Double.infinity) == Double.infinity)
    }

    @Test func nanNegate() {
        let result = IEEE_754.Arithmetic.negate(Double.nan)
        #expect(result.isNaN)
    }

    @Test func doubleNegation() {
        #expect(IEEE_754.Arithmetic.negate(IEEE_754.Arithmetic.negate(3.14)) == 3.14)
    }
}

// MARK: - Edge Cases Tests

@Suite("IEEE_754.Arithmetic - Edge Cases")
struct ArithmeticEdgeCasesTests {
    @Test func maxFiniteOperations() {
        let max = Double.greatestFiniteMagnitude

        // Addition overflow
        let sum = IEEE_754.Arithmetic.addition(max, max)
        #expect(sum == Double.infinity)

        // Multiplication overflow
        let product = IEEE_754.Arithmetic.multiplication(max, 2.0)
        #expect(product == Double.infinity)
    }

    @Test func minFiniteOperations() {
        let min = Double.leastNormalMagnitude

        // Division producing subnormal
        let quotient = IEEE_754.Arithmetic.division(min, 2.0)
        #expect(quotient < min)

        // Multiplication producing subnormal
        let product = IEEE_754.Arithmetic.multiplication(min, 0.5)
        #expect(product < min)
    }

    @Test func subnormalArithmetic() {
        let subnormal = Double.leastNonzeroMagnitude

        let sum = IEEE_754.Arithmetic.addition(subnormal, subnormal)
        #expect(sum > 0)

        let product = IEEE_754.Arithmetic.multiplication(subnormal, 0.5)
        #expect(product >= 0)  // May underflow to 0
    }

    @Test func mixedSignZeros() {
        // IEEE 754 signed zero behavior
        let posZero = 0.0
        let negZero = -0.0

        #expect(IEEE_754.Arithmetic.addition(posZero, negZero) == 0.0)
        #expect(IEEE_754.Arithmetic.subtraction(posZero, negZero) == 0.0)
    }
}

// MARK: - Consistency Tests

@Suite("IEEE_754.Arithmetic - Consistency with Operators")
struct ArithmeticConsistencyTests {
    @Test func additionConsistency() {
        let values: [(Double, Double)] = [(3.0, 2.0), (-5.0, 3.0), (0.0, 0.0), (1e100, 1e-100)]

        for (a, b) in values {
            let expected = a + b
            let actual = IEEE_754.Arithmetic.addition(a, b)
            #expect(expected == actual)
        }
    }

    @Test func multiplicationConsistency() {
        let values: [(Double, Double)] = [(3.0, 2.0), (-5.0, 3.0), (2.0, 0.5), (1e50, 1e-50)]

        for (a, b) in values {
            let expected = a * b
            let actual = IEEE_754.Arithmetic.multiplication(a, b)
            #expect(expected == actual)
        }
    }

    @Test func squareRootConsistency() {
        let values = [4.0, 9.0, 2.0, 0.5, 1e100, 1e-100]

        for value in values {
            let expected = value.squareRoot()
            let actual = IEEE_754.Arithmetic.squareRoot(value)
            #expect(expected == actual)
        }
    }
}
