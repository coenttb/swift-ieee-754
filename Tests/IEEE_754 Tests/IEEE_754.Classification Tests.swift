// IEEE_754.Classification Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.7 Classification operations

import Testing

@testable import IEEE_754

// Make NumberClass conform to Sendable (retroactive conformance)
extension IEEE_754.Classification.NumberClass: @unchecked Sendable {}

// MARK: - Double Classification Tests

@Suite("IEEE_754.Classification - Double isSignMinus")
struct DoubleIsSignMinusTests {
    @Test(arguments: [
        (3.14, false),
        (-3.14, true),
        (0.0, false),
        (-0.0, true),
        (Double.infinity, false),
        (-Double.infinity, true),
        (Double.leastNonzeroMagnitude, false),
        (-Double.leastNonzeroMagnitude, true)
    ])
    func isSignMinus(value: Double, expected: Bool) {
        #expect(IEEE_754.Classification.isSignMinus(value) == expected, "isSignMinus(\(value)) should be \(expected)")
    }

    @Test func nanSignBits() {
        let positiveNaN = Double.nan
        let negativeNaN = -Double.nan
        #expect(!IEEE_754.Classification.isSignMinus(positiveNaN), "Positive NaN should not have sign bit set")
        #expect(IEEE_754.Classification.isSignMinus(negativeNaN), "Negative NaN should have sign bit set")
    }
}

@Suite("IEEE_754.Classification - Double isNormal")
struct DoubleIsNormalTests {
    @Test(arguments: [1.0, -1.0, 3.14, -2.71, 1000.0, -0.001])
    func normalValues(value: Double) {
        #expect(IEEE_754.Classification.isNormal(value), "\(value) should be normal")
    }

    @Test(arguments: [0.0, -0.0])
    func zeros(value: Double) {
        #expect(!IEEE_754.Classification.isNormal(value), "\(value) should not be normal")
    }

    @Test(arguments: [Double.infinity, -Double.infinity])
    func infinities(value: Double) {
        #expect(!IEEE_754.Classification.isNormal(value), "\(value) should not be normal")
    }

    @Test(arguments: [Double.nan, Double.signalingNaN])
    func nans(value: Double) {
        #expect(!IEEE_754.Classification.isNormal(value), "NaN should not be normal")
    }

    @Test func subnormals() {
        let subnormal = Double.leastNonzeroMagnitude
        #expect(!IEEE_754.Classification.isNormal(subnormal), "Subnormal should not be normal")
        #expect(!IEEE_754.Classification.isNormal(-subnormal), "Negative subnormal should not be normal")
    }

    @Test func minNormal() {
        let minNorm = Double.leastNormalMagnitude
        #expect(IEEE_754.Classification.isNormal(minNorm), "leastNormalMagnitude should be normal")
        #expect(IEEE_754.Classification.isNormal(-minNorm), "Negative leastNormalMagnitude should be normal")
    }
}

@Suite("IEEE_754.Classification - Double isFinite")
struct DoubleIsFiniteTests {
    @Test(arguments: [0.0, -0.0, 1.0, -1.0, 3.14, -2.71, 1e308, -1e308])
    func finiteValues(value: Double) {
        #expect(IEEE_754.Classification.isFinite(value), "\(value) should be finite")
    }

    @Test(arguments: [Double.infinity, -Double.infinity])
    func infinities(value: Double) {
        #expect(!IEEE_754.Classification.isFinite(value), "\(value) should not be finite")
    }

    @Test(arguments: [Double.nan, Double.signalingNaN])
    func nans(value: Double) {
        #expect(!IEEE_754.Classification.isFinite(value), "NaN should not be finite")
    }

    @Test func extremeFiniteValues() {
        let maxFinite = Double.greatestFiniteMagnitude
        #expect(IEEE_754.Classification.isFinite(maxFinite), "greatestFiniteMagnitude should be finite")
        #expect(IEEE_754.Classification.isFinite(-maxFinite), "Negative greatestFiniteMagnitude should be finite")
    }

    @Test func subnormals() {
        let subnormal = Double.leastNonzeroMagnitude
        #expect(IEEE_754.Classification.isFinite(subnormal), "Subnormal should be finite")
    }
}

@Suite("IEEE_754.Classification - Double isZero")
struct DoubleIsZeroTests {
    @Test(arguments: [0.0, -0.0])
    func zeros(value: Double) {
        #expect(IEEE_754.Classification.isZero(value), "\(value) should be zero")
    }

    @Test(arguments: [1.0, -1.0, 0.1, -0.1, Double.leastNonzeroMagnitude, -Double.leastNonzeroMagnitude])
    func nonZeros(value: Double) {
        #expect(!IEEE_754.Classification.isZero(value), "\(value) should not be zero")
    }

    @Test(arguments: [Double.infinity, -Double.infinity, Double.nan])
    func specialValues(value: Double) {
        #expect(!IEEE_754.Classification.isZero(value), "\(value) should not be zero")
    }
}

@Suite("IEEE_754.Classification - Double isSubnormal")
struct DoubleIsSubnormalTests {
    @Test func minSubnormal() {
        let minSubnorm = Double.leastNonzeroMagnitude
        #expect(IEEE_754.Classification.isSubnormal(minSubnorm), "leastNonzeroMagnitude should be subnormal")
        #expect(IEEE_754.Classification.isSubnormal(-minSubnorm), "Negative leastNonzeroMagnitude should be subnormal")
    }

    @Test func maxSubnormal() {
        let maxSubnorm = Double.leastNormalMagnitude.nextDown
        #expect(IEEE_754.Classification.isSubnormal(maxSubnorm), "Value just below leastNormalMagnitude should be subnormal")
    }

    @Test(arguments: [0.0, -0.0])
    func zeros(value: Double) {
        #expect(!IEEE_754.Classification.isSubnormal(value), "\(value) should not be subnormal")
    }

    @Test(arguments: [1.0, -1.0, 3.14])
    func normalValues(value: Double) {
        #expect(!IEEE_754.Classification.isSubnormal(value), "\(value) should not be subnormal")
    }

    @Test(arguments: [Double.infinity, -Double.infinity, Double.nan])
    func specialValues(value: Double) {
        #expect(!IEEE_754.Classification.isSubnormal(value), "\(value) should not be subnormal")
    }
}

@Suite("IEEE_754.Classification - Double isInfinite")
struct DoubleIsInfiniteTests {
    @Test(arguments: [Double.infinity, -Double.infinity])
    func infinities(value: Double) {
        #expect(IEEE_754.Classification.isInfinite(value), "\(value) should be infinite")
    }

    @Test(arguments: [0.0, -0.0, 1.0, -1.0, 3.14, -2.71])
    func finiteValues(value: Double) {
        #expect(!IEEE_754.Classification.isInfinite(value), "\(value) should not be infinite")
    }

    @Test(arguments: [Double.nan, Double.signalingNaN])
    func nans(value: Double) {
        #expect(!IEEE_754.Classification.isInfinite(value), "NaN should not be infinite")
    }

    @Test func overflow() {
        let maxFinite = Double.greatestFiniteMagnitude
        let overflow = maxFinite * 2.0
        #expect(IEEE_754.Classification.isInfinite(overflow), "Overflow should produce infinity")
    }
}

@Suite("IEEE_754.Classification - Double isNaN")
struct DoubleIsNaNTests {
    @Test(arguments: [Double.nan, Double.signalingNaN, -Double.nan])
    func nans(value: Double) {
        #expect(IEEE_754.Classification.isNaN(value), "\(value) should be NaN")
    }

    @Test(arguments: [0.0, -0.0, 1.0, -1.0, Double.infinity, -Double.infinity])
    func nonNaNs(value: Double) {
        #expect(!IEEE_754.Classification.isNaN(value), "\(value) should not be NaN")
    }

    @Test func nanOperations() {
        let result = 0.0 / 0.0
        #expect(IEEE_754.Classification.isNaN(result), "0/0 should produce NaN")
    }
}

@Suite("IEEE_754.Classification - Double isSignaling")
struct DoubleIsSignalingTests {
    @Test func signalingNaN() {
        let snan = Double.signalingNaN
        #expect(IEEE_754.Classification.isSignaling(snan), "signalingNaN should be signaling")
    }

    @Test func quietNaN() {
        let qnan = Double.nan
        #expect(!IEEE_754.Classification.isSignaling(qnan), "quiet NaN should not be signaling")
    }

    @Test(arguments: [0.0, 1.0, -1.0, Double.infinity, -Double.infinity])
    func nonNaNs(value: Double) {
        #expect(!IEEE_754.Classification.isSignaling(value), "\(value) should not be signaling")
    }
}

@Suite("IEEE_754.Classification - Double isCanonical")
struct DoubleIsCanonicalTests {
    @Test(arguments: [0.0, -0.0, 1.0, -1.0, 3.14, Double.infinity, -Double.infinity, Double.nan, Double.signalingNaN])
    func allValuesCanonical(value: Double) {
        #expect(IEEE_754.Classification.isCanonical(value), "All binary format values should be canonical")
    }
}

@Suite("IEEE_754.Classification - Double radix")
struct DoubleRadixTests {
    @Test(arguments: [0.0, 1.0, -1.0, 3.14, Double.infinity, Double.nan])
    func radixIsTwo(value: Double) {
        #expect(IEEE_754.Classification.radix(value) == 2, "Radix should always be 2 for binary formats")
    }
}

@Suite("IEEE_754.Classification - Double numberClass")
struct DoubleNumberClassTests {
    @Test func signalingNaN() {
        let snan = Double.signalingNaN
        #expect(IEEE_754.Classification.numberClass(snan) == .nan(.signaling))
    }

    @Test func quietNaN() {
        let qnan = Double.nan
        #expect(IEEE_754.Classification.numberClass(qnan) == .nan(.quiet))
    }

    @Test func negativeInfinity() {
        #expect(IEEE_754.Classification.numberClass(-Double.infinity) == .negative(.infinity))
    }

    @Test func negativeNormal() {
        #expect(IEEE_754.Classification.numberClass(-3.14) == .negative(.normal))
    }

    @Test func negativeSubnormal() {
        let negSubnorm = -Double.leastNonzeroMagnitude
        #expect(IEEE_754.Classification.numberClass(negSubnorm) == .negative(.subnormal))
    }

    @Test func negativeZero() {
        #expect(IEEE_754.Classification.numberClass(-0.0) == .negative(.zero))
    }

    @Test func positiveZero() {
        #expect(IEEE_754.Classification.numberClass(0.0) == .positive(.zero))
    }

    @Test func positiveSubnormal() {
        let posSubnorm = Double.leastNonzeroMagnitude
        #expect(IEEE_754.Classification.numberClass(posSubnorm) == .positive(.subnormal))
    }

    @Test func positiveNormal() {
        #expect(IEEE_754.Classification.numberClass(3.14) == .positive(.normal))
    }

    @Test func positiveInfinity() {
        #expect(IEEE_754.Classification.numberClass(Double.infinity) == .positive(.infinity))
    }

    @Test(arguments: [
        (-Double.infinity, IEEE_754.Classification.NumberClass.negative(.infinity)),
        (-100.0, .negative(.normal)),
        (-0.0, .negative(.zero)),
        (0.0, .positive(.zero)),
        (100.0, .positive(.normal)),
        (Double.infinity, .positive(.infinity))
    ])
    func numberClassCases(value: Double, expected: IEEE_754.Classification.NumberClass) {
        #expect(IEEE_754.Classification.numberClass(value) == expected)
    }
}

// MARK: - Float Classification Tests

@Suite("IEEE_754.Classification - Float isSignMinus")
struct FloatIsSignMinusTests {
    @Test(arguments: [
        (Float(3.14), false),
        (Float(-3.14), true),
        (Float(0.0), false),
        (Float(-0.0), true),
        (Float.infinity, false),
        (-Float.infinity, true)
    ])
    func isSignMinus(value: Float, expected: Bool) {
        #expect(IEEE_754.Classification.isSignMinus(value) == expected)
    }
}

@Suite("IEEE_754.Classification - Float isNormal")
struct FloatIsNormalTests {
    @Test(arguments: [Float(1.0), Float(-1.0), Float(3.14)])
    func normalValues(value: Float) {
        #expect(IEEE_754.Classification.isNormal(value))
    }

    @Test(arguments: [Float(0.0), Float.infinity, Float.nan])
    func nonNormalValues(value: Float) {
        #expect(!IEEE_754.Classification.isNormal(value))
    }

    @Test func subnormals() {
        let subnormal = Float.leastNonzeroMagnitude
        #expect(!IEEE_754.Classification.isNormal(subnormal))
    }
}

@Suite("IEEE_754.Classification - Float isFinite")
struct FloatIsFiniteTests {
    @Test(arguments: [Float(0.0), Float(1.0), Float(-1.0), Float(3.14)])
    func finiteValues(value: Float) {
        #expect(IEEE_754.Classification.isFinite(value))
    }

    @Test(arguments: [Float.infinity, -Float.infinity, Float.nan])
    func nonFiniteValues(value: Float) {
        #expect(!IEEE_754.Classification.isFinite(value))
    }
}

@Suite("IEEE_754.Classification - Float numberClass")
struct FloatNumberClassTests {
    @Test(arguments: [
        (Float(-0.0), IEEE_754.Classification.NumberClass.negative(.zero)),
        (Float(0.0), .positive(.zero)),
        (Float(-3.14), .negative(.normal)),
        (Float(3.14), .positive(.normal)),
        (-Float.infinity, .negative(.infinity)),
        (Float.infinity, .positive(.infinity))
    ])
    func numberClassCases(value: Float, expected: IEEE_754.Classification.NumberClass) {
        #expect(IEEE_754.Classification.numberClass(value) == expected)
    }

    @Test func quietNaN() {
        #expect(IEEE_754.Classification.numberClass(Float.nan) == .nan(.quiet))
    }

    @Test func signalingNaN() {
        #expect(IEEE_754.Classification.numberClass(Float.signalingNaN) == .nan(.signaling))
    }

    @Test func subnormals() {
        let posSubnorm = Float.leastNonzeroMagnitude
        let negSubnorm = -Float.leastNonzeroMagnitude
        #expect(IEEE_754.Classification.numberClass(posSubnorm) == .positive(.subnormal))
        #expect(IEEE_754.Classification.numberClass(negSubnorm) == .negative(.subnormal))
    }
}
