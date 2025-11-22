// IEEE_754.Scaling Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.3 Scaling operations

import Testing
import Darwin

@testable import IEEE_754

// MARK: - Double Scaling Tests

@Suite("IEEE_754.Scaling - Double scaleB")
struct DoubleScaleBTests {
    @Test(arguments: [
        (1.0, 0, 1.0),
        (1.0, 1, 2.0),
        (1.0, 2, 4.0),
        (1.0, 10, 1024.0),
        (3.14, 2, 12.56),
        (1.0, -1, 0.5),
        (1.0, -2, 0.25),
        (8.0, -3, 1.0)
    ])
    func powersOfTwo(value: Double, n: Int, expected: Double) {
        let result = IEEE_754.Scaling.scaleB(value, n)
        #expect(result == expected, "scaleB(\(value), \(n)) should be \(expected)")
    }

    @Test func largeScale() {
        let result = IEEE_754.Scaling.scaleB(1.0, 2000)
        #expect(result.isInfinite, "Scaling by large exponent should overflow to infinity")
        #expect(result.sign == .plus, "Positive overflow should be positive infinity")
    }

    @Test func smallScale() {
        let result = IEEE_754.Scaling.scaleB(1.0, -1100)
        #expect(result == 0.0, "Scaling by large negative exponent should underflow to zero")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.scaleB(0.0, 10) == 0.0, "scaleB(0, n) should be 0")
        #expect(IEEE_754.Scaling.scaleB(-0.0, 10) == -0.0, "scaleB(-0, n) should be -0")
        #expect(IEEE_754.Scaling.scaleB(Double.infinity, 10).isInfinite, "scaleB(inf, n) should be inf")
        #expect(IEEE_754.Scaling.scaleB(Double.nan, 10).isNaN, "scaleB(NaN, n) should be NaN")
    }

    @Test func negativeValues() {
        #expect(IEEE_754.Scaling.scaleB(-1.0, 2) == -4.0, "scaleB(-1, 2) should be -4")
        #expect(IEEE_754.Scaling.scaleB(-3.14, 1) == -6.28, "scaleB preserves sign")
    }

    @Test func exactOperation() {
        // scaleB should be exact (no rounding) for normal values
        let value = 1.23456789
        let scaled = IEEE_754.Scaling.scaleB(value, 5)
        let unscaled = IEEE_754.Scaling.scaleB(scaled, -5)
        #expect(unscaled == value, "scaleB should be reversible")
    }
}

@Suite("IEEE_754.Scaling - Double logB")
struct DoubleLogBTests {
    @Test(arguments: [
        (1.0, 0),
        (2.0, 1),
        (4.0, 2),
        (8.0, 3),
        (1024.0, 10),
        (0.5, -1),
        (0.25, -2)
    ])
    func powersOfTwo(value: Double, expected: Int) {
        #expect(IEEE_754.Scaling.logB(value) == expected, "logB(\(value)) should be \(expected)")
    }

    @Test func rangeValues() {
        #expect(IEEE_754.Scaling.logB(1.5) == 0, "logB(1.5) in range [1,2) should be 0")
        #expect(IEEE_754.Scaling.logB(1.999) == 0, "logB(1.999) in range [1,2) should be 0")
        #expect(IEEE_754.Scaling.logB(3.0) == 1, "logB(3.0) in range [2,4) should be 1")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.logB(0.0) == Int.min, "logB(0) should be Int.min")
        #expect(IEEE_754.Scaling.logB(-0.0) == Int.min, "logB(-0) should be Int.min")
        #expect(IEEE_754.Scaling.logB(Double.infinity) == Int.max, "logB(inf) should be Int.max")
        #expect(IEEE_754.Scaling.logB(-Double.infinity) == Int.max, "logB(-inf) should be Int.max")
        #expect(IEEE_754.Scaling.logB(Double.nan) == Int.max, "logB(NaN) should be Int.max")
    }

    @Test func negativeValues() {
        #expect(IEEE_754.Scaling.logB(-8.0) == 3, "logB(-8) should be 3 (sign ignored)")
        #expect(IEEE_754.Scaling.logB(-0.5) == -1, "logB(-0.5) should be -1")
    }

    @Test func subnormals() {
        let subnorm = Double.leastNonzeroMagnitude
        let exponent = IEEE_754.Scaling.logB(subnorm)
        #expect(exponent < -1022, "Subnormal exponent should be less than emin")
    }
}

@Suite("IEEE_754.Scaling - Double exponent")
struct DoubleExponentTests {
    @Test(arguments: [
        (1.0, 0.0),
        (2.0, 1.0),
        (8.0, 3.0),
        (0.5, -1.0)
    ])
    func powersOfTwo(value: Double, expected: Double) {
        #expect(IEEE_754.Scaling.exponent(value) == expected, "exponent(\(value)) should be \(expected)")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.exponent(0.0) == -Double.infinity, "exponent(0) should be -infinity")
        #expect(IEEE_754.Scaling.exponent(Double.infinity) == Double.infinity, "exponent(inf) should be infinity")
        #expect(IEEE_754.Scaling.exponent(Double.nan).isNaN, "exponent(NaN) should be NaN")
    }
}

@Suite("IEEE_754.Scaling - Double significand")
struct DoubleSignificandTests {
    @Test func powersOfTwo() {
        #expect(IEEE_754.Scaling.significand(8.0) == 1.0, "significand(8.0) should be 1.0")
        #expect(IEEE_754.Scaling.significand(4.0) == 1.0, "significand(4.0) should be 1.0")
        #expect(IEEE_754.Scaling.significand(2.0) == 1.0, "significand(2.0) should be 1.0")
    }

    @Test func nonPowersOfTwo() {
        #expect(IEEE_754.Scaling.significand(12.0) == 1.5, "significand(12.0) should be 1.5 (12 = 1.5 × 2^3)")
        #expect(IEEE_754.Scaling.significand(6.0) == 1.5, "significand(6.0) should be 1.5 (6 = 1.5 × 2^2)")
    }

    @Test func valueReconstruction() {
        let value = 12.34
        let sig = IEEE_754.Scaling.significand(value)
        let exp = IEEE_754.Scaling.exponent(value)
        let reconstructed = sig * pow(2.0, exp)
        #expect(reconstructed == value, "value should equal significand × 2^exponent")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.significand(0.0) == 0.0, "significand(0) should be 0")
        #expect(IEEE_754.Scaling.significand(Double.infinity).isInfinite, "significand(inf) should be inf")
        #expect(IEEE_754.Scaling.significand(Double.nan).isNaN, "significand(NaN) should be NaN")
    }
}

// MARK: - Float Scaling Tests

@Suite("IEEE_754.Scaling - Float scaleB")
struct FloatScaleBTests {
    @Test(arguments: [
        (Float(1.0), 0, Float(1.0)),
        (Float(1.0), 1, Float(2.0)),
        (Float(1.0), 2, Float(4.0)),
        (Float(1.0), 10, Float(1024.0)),
        (Float(1.0), -1, Float(0.5))
    ])
    func powersOfTwo(value: Float, n: Int, expected: Float) {
        let result = IEEE_754.Scaling.scaleB(value, n)
        #expect(result == expected, "scaleB(\(value), \(n)) should be \(expected)")
    }

    @Test func largeScale() {
        let result = IEEE_754.Scaling.scaleB(Float(1.0), 200)
        #expect(result.isInfinite, "Scaling by large exponent should overflow to infinity")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.scaleB(Float(0.0), 10) == Float(0.0), "scaleB(0, n) should be 0")
        #expect(IEEE_754.Scaling.scaleB(Float.infinity, 10).isInfinite, "scaleB(inf, n) should be inf")
        #expect(IEEE_754.Scaling.scaleB(Float.nan, 10).isNaN, "scaleB(NaN, n) should be NaN")
    }
}

@Suite("IEEE_754.Scaling - Float logB")
struct FloatLogBTests {
    @Test(arguments: [
        (Float(1.0), 0),
        (Float(2.0), 1),
        (Float(8.0), 3),
        (Float(0.5), -1)
    ])
    func powersOfTwo(value: Float, expected: Int) {
        #expect(IEEE_754.Scaling.logB(value) == expected, "logB(\(value)) should be \(expected)")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.logB(Float(0.0)) == Int.min, "logB(0) should be Int.min")
        #expect(IEEE_754.Scaling.logB(Float.infinity) == Int.max, "logB(inf) should be Int.max")
        #expect(IEEE_754.Scaling.logB(Float.nan) == Int.max, "logB(NaN) should be Int.max")
    }
}

@Suite("IEEE_754.Scaling - Float exponent")
struct FloatExponentTests {
    @Test(arguments: [
        (Float(1.0), Float(0.0)),
        (Float(2.0), Float(1.0)),
        (Float(8.0), Float(3.0))
    ])
    func powersOfTwo(value: Float, expected: Float) {
        #expect(IEEE_754.Scaling.exponent(value) == expected, "exponent(\(value)) should be \(expected)")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Scaling.exponent(Float(0.0)) == -Float.infinity, "exponent(0) should be -infinity")
        #expect(IEEE_754.Scaling.exponent(Float.infinity) == Float.infinity, "exponent(inf) should be infinity")
        #expect(IEEE_754.Scaling.exponent(Float.nan).isNaN, "exponent(NaN) should be NaN")
    }
}

@Suite("IEEE_754.Scaling - Float significand")
struct FloatSignificandTests {
    @Test func powersOfTwo() {
        #expect(IEEE_754.Scaling.significand(Float(8.0)) == Float(1.0), "significand(8.0) should be 1.0")
        #expect(IEEE_754.Scaling.significand(Float(4.0)) == Float(1.0), "significand(4.0) should be 1.0")
    }

    @Test func valueReconstruction() {
        let value: Float = 12.34
        let sig = IEEE_754.Scaling.significand(value)
        let exp = IEEE_754.Scaling.exponent(value)
        let reconstructed = sig * Float(pow(2.0, Double(exp)))
        #expect(reconstructed == value, "value should equal significand × 2^exponent")
    }
}

// MARK: - Edge Cases

@Suite("IEEE_754.Scaling - Edge Cases")
struct ScalingEdgeCasesTests {
    @Test func subnormalScaling() {
        let subnorm = Double.leastNonzeroMagnitude
        let scaled = IEEE_754.Scaling.scaleB(subnorm, 100)
        #expect(scaled.isNormal, "Scaling subnormal up should produce normal")

        let scaledDown = IEEE_754.Scaling.scaleB(scaled, -100)
        #expect(scaledDown.isSubnormal, "Scaling back should produce subnormal")
    }

    @Test func normalToSubnormal() {
        let normal = Double.leastNormalMagnitude
        let subnorm = IEEE_754.Scaling.scaleB(normal, -1)
        #expect(subnorm.isSubnormal, "Scaling leastNormalMagnitude down should produce subnormal")
    }

    @Test func exactBoundaries() {
        let maxNorm = Double.greatestFiniteMagnitude
        let nextExp = IEEE_754.Scaling.logB(maxNorm)
        #expect(nextExp > 0, "maxNormal should have positive exponent")
    }
}
