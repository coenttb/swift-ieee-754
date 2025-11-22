// Rounding Tests.swift
// swift-ieee-754
//
// Tests for IEEE 754-2019 Section 5.9-5.10: Round to Integral Operations

import Testing
@testable import IEEE_754

@Suite("IEEE 754 Rounding Operations")
struct RoundingTests {}

// MARK: - Double Floor Tests

extension RoundingTests {
    @Test("floor rounds toward negative infinity", arguments: [
        (3.7, 3.0),
        (3.0, 3.0),
        (3.2, 3.0),
        (-3.2, -4.0),
        (-3.7, -4.0),
        (-3.0, -3.0),
        (0.0, 0.0),
        (-0.0, -0.0),
        (0.1, 0.0),
        (-0.1, -1.0),
    ])
    func doubleFloor(value: Double, expected: Double) {
        #expect(IEEE_754.Rounding.floor(value) == expected)
        #expect(value.ieee754.floor == expected)
    }

    @Test("floor handles special values")
    func floorSpecialValues() {
        #expect(IEEE_754.Rounding.floor(Double.infinity) == Double.infinity)
        #expect(IEEE_754.Rounding.floor(-Double.infinity) == -Double.infinity)
        #expect(IEEE_754.Rounding.floor(Double.nan).isNaN)
        #expect(IEEE_754.Rounding.floor(0.0) == 0.0)
        #expect(IEEE_754.Rounding.floor(-0.0) == -0.0)
    }
}

// MARK: - Double Ceil Tests

extension RoundingTests {
    @Test("ceil rounds toward positive infinity", arguments: [
        (3.2, 4.0),
        (3.0, 3.0),
        (3.7, 4.0),
        (-3.7, -3.0),
        (-3.2, -3.0),
        (-3.0, -3.0),
        (0.0, 0.0),
        (-0.0, -0.0),
        (0.1, 1.0),
        (-0.1, -0.0),
    ])
    func doubleCeil(value: Double, expected: Double) {
        #expect(IEEE_754.Rounding.ceil(value) == expected)
        #expect(value.ieee754.ceil == expected)
    }

    @Test("ceil handles special values")
    func ceilSpecialValues() {
        #expect(IEEE_754.Rounding.ceil(Double.infinity) == Double.infinity)
        #expect(IEEE_754.Rounding.ceil(-Double.infinity) == -Double.infinity)
        #expect(IEEE_754.Rounding.ceil(Double.nan).isNaN)
        #expect(IEEE_754.Rounding.ceil(0.0) == 0.0)
        #expect(IEEE_754.Rounding.ceil(-0.0) == -0.0)
    }
}

// MARK: - Double Round Tests

extension RoundingTests {
    @Test("round rounds to nearest (ties to even)", arguments: [
        (3.4, 3.0),
        (3.5, 4.0),  // Ties to even: 4 is even
        (3.6, 4.0),
        (4.5, 4.0),  // Ties to even: 4 is even
        (5.5, 6.0),  // Ties to even: 6 is even
        (-3.4, -3.0),
        (-3.5, -4.0), // Ties to even: -4 is even
        (-3.6, -4.0),
        (-4.5, -4.0), // Ties to even: -4 is even
        (-5.5, -6.0), // Ties to even: -6 is even
        (0.5, 0.0),   // Ties to even: 0 is even
        (-0.5, -0.0), // Ties to even: 0 is even
    ])
    func doubleRound(value: Double, expected: Double) {
        #expect(IEEE_754.Rounding.round(value) == expected)
        #expect(value.ieee754.round == expected)
    }

    @Test("round handles special values")
    func roundSpecialValues() {
        #expect(IEEE_754.Rounding.round(Double.infinity) == Double.infinity)
        #expect(IEEE_754.Rounding.round(-Double.infinity) == -Double.infinity)
        #expect(IEEE_754.Rounding.round(Double.nan).isNaN)
        #expect(IEEE_754.Rounding.round(0.0) == 0.0)
        #expect(IEEE_754.Rounding.round(-0.0) == -0.0)
    }
}

// MARK: - Double Trunc Tests

extension RoundingTests {
    @Test("trunc rounds toward zero", arguments: [
        (3.7, 3.0),
        (3.2, 3.0),
        (3.0, 3.0),
        (-3.2, -3.0),
        (-3.7, -3.0),
        (-3.0, -3.0),
        (0.0, 0.0),
        (-0.0, -0.0),
        (0.9, 0.0),
        (-0.9, -0.0),
    ])
    func doubleTrunc(value: Double, expected: Double) {
        #expect(IEEE_754.Rounding.trunc(value) == expected)
        #expect(value.ieee754.trunc == expected)
    }

    @Test("trunc handles special values")
    func truncSpecialValues() {
        #expect(IEEE_754.Rounding.trunc(Double.infinity) == Double.infinity)
        #expect(IEEE_754.Rounding.trunc(-Double.infinity) == -Double.infinity)
        #expect(IEEE_754.Rounding.trunc(Double.nan).isNaN)
        #expect(IEEE_754.Rounding.trunc(0.0) == 0.0)
        #expect(IEEE_754.Rounding.trunc(-0.0) == -0.0)
    }
}

// MARK: - Float Floor Tests

extension RoundingTests {
    @Test("float floor rounds toward negative infinity", arguments: [
        (Float(3.7), Float(3.0)),
        (Float(3.0), Float(3.0)),
        (Float(-3.2), Float(-4.0)),
        (Float(-3.7), Float(-4.0)),
        (Float(0.0), Float(0.0)),
    ])
    func floatFloor(value: Float, expected: Float) {
        #expect(IEEE_754.Rounding.floor(value) == expected)
        #expect(value.ieee754.floor == expected)
    }

    @Test("float floor handles special values")
    func floatFloorSpecialValues() {
        #expect(IEEE_754.Rounding.floor(Float.infinity) == Float.infinity)
        #expect(IEEE_754.Rounding.floor(-Float.infinity) == -Float.infinity)
        #expect(IEEE_754.Rounding.floor(Float.nan).isNaN)
    }
}

// MARK: - Float Ceil Tests

extension RoundingTests {
    @Test("float ceil rounds toward positive infinity", arguments: [
        (Float(3.2), Float(4.0)),
        (Float(3.0), Float(3.0)),
        (Float(-3.7), Float(-3.0)),
        (Float(-3.2), Float(-3.0)),
        (Float(0.0), Float(0.0)),
    ])
    func floatCeil(value: Float, expected: Float) {
        #expect(IEEE_754.Rounding.ceil(value) == expected)
        #expect(value.ieee754.ceil == expected)
    }

    @Test("float ceil handles special values")
    func floatCeilSpecialValues() {
        #expect(IEEE_754.Rounding.ceil(Float.infinity) == Float.infinity)
        #expect(IEEE_754.Rounding.ceil(-Float.infinity) == -Float.infinity)
        #expect(IEEE_754.Rounding.ceil(Float.nan).isNaN)
    }
}

// MARK: - Float Round Tests

extension RoundingTests {
    @Test("float round rounds to nearest (ties to even)", arguments: [
        (Float(3.4), Float(3.0)),
        (Float(3.5), Float(4.0)),
        (Float(3.6), Float(4.0)),
        (Float(4.5), Float(4.0)),
        (Float(-3.5), Float(-4.0)),
        (Float(0.5), Float(0.0)),
    ])
    func floatRound(value: Float, expected: Float) {
        #expect(IEEE_754.Rounding.round(value) == expected)
        #expect(value.ieee754.round == expected)
    }

    @Test("float round handles special values")
    func floatRoundSpecialValues() {
        #expect(IEEE_754.Rounding.round(Float.infinity) == Float.infinity)
        #expect(IEEE_754.Rounding.round(-Float.infinity) == -Float.infinity)
        #expect(IEEE_754.Rounding.round(Float.nan).isNaN)
    }
}

// MARK: - Float Trunc Tests

extension RoundingTests {
    @Test("float trunc rounds toward zero", arguments: [
        (Float(3.7), Float(3.0)),
        (Float(3.2), Float(3.0)),
        (Float(-3.2), Float(-3.0)),
        (Float(-3.7), Float(-3.0)),
        (Float(0.0), Float(0.0)),
    ])
    func floatTrunc(value: Float, expected: Float) {
        #expect(IEEE_754.Rounding.trunc(value) == expected)
        #expect(value.ieee754.trunc == expected)
    }

    @Test("float trunc handles special values")
    func floatTruncSpecialValues() {
        #expect(IEEE_754.Rounding.trunc(Float.infinity) == Float.infinity)
        #expect(IEEE_754.Rounding.trunc(-Float.infinity) == -Float.infinity)
        #expect(IEEE_754.Rounding.trunc(Float.nan).isNaN)
    }
}

// MARK: - Edge Cases

extension RoundingTests {
    @Test("large values are handled correctly")
    func largeValues() {
        let large = 1_000_000_000.7
        #expect(IEEE_754.Rounding.floor(large) == 1_000_000_000.0)
        #expect(IEEE_754.Rounding.ceil(large) == 1_000_000_001.0)
        #expect(IEEE_754.Rounding.trunc(large) == 1_000_000_000.0)
    }

    @Test("very small values are handled correctly")
    func verySmallValues() {
        let small = 0.0000001
        #expect(IEEE_754.Rounding.floor(small) == 0.0)
        #expect(IEEE_754.Rounding.ceil(small) == 1.0)
        #expect(IEEE_754.Rounding.round(small) == 0.0)
        #expect(IEEE_754.Rounding.trunc(small) == 0.0)
    }

    @Test("subnormal values are handled correctly")
    func subnormalValues() {
        let subnormal = Double.leastNonzeroMagnitude
        #expect(IEEE_754.Rounding.floor(subnormal) == 0.0)
        #expect(IEEE_754.Rounding.ceil(subnormal) == 1.0)
        #expect(IEEE_754.Rounding.round(subnormal) == 0.0)
        #expect(IEEE_754.Rounding.trunc(subnormal) == 0.0)
    }

    @Test("maximum finite values are handled correctly")
    func maximumValues() {
        let max = Double.greatestFiniteMagnitude
        #expect(IEEE_754.Rounding.floor(max) == max)
        #expect(IEEE_754.Rounding.ceil(max) == max)
        #expect(IEEE_754.Rounding.round(max) == max)
        #expect(IEEE_754.Rounding.trunc(max) == max)
    }
}

// MARK: - IEEE 754 Conformance

extension RoundingTests {
    @Test("floor preserves sign of zero")
    func floorSignOfZero() {
        let positiveZero = IEEE_754.Rounding.floor(0.0)
        let negativeZero = IEEE_754.Rounding.floor(-0.0)
        #expect(positiveZero == 0.0)
        #expect(negativeZero == -0.0)
        #expect(positiveZero.sign == .plus)
        #expect(negativeZero.sign == .minus)
    }

    @Test("ceil preserves sign of zero")
    func ceilSignOfZero() {
        let positiveZero = IEEE_754.Rounding.ceil(0.0)
        let negativeZero = IEEE_754.Rounding.ceil(-0.0)
        #expect(positiveZero == 0.0)
        #expect(negativeZero == -0.0)
        #expect(positiveZero.sign == .plus)
        #expect(negativeZero.sign == .minus)
    }

    @Test("round preserves sign of zero")
    func roundSignOfZero() {
        let positiveZero = IEEE_754.Rounding.round(0.0)
        let negativeZero = IEEE_754.Rounding.round(-0.0)
        #expect(positiveZero == 0.0)
        #expect(negativeZero == -0.0)
        #expect(positiveZero.sign == .plus)
        #expect(negativeZero.sign == .minus)
    }

    @Test("trunc preserves sign of zero")
    func truncSignOfZero() {
        let positiveZero = IEEE_754.Rounding.trunc(0.0)
        let negativeZero = IEEE_754.Rounding.trunc(-0.0)
        #expect(positiveZero == 0.0)
        #expect(negativeZero == -0.0)
        #expect(positiveZero.sign == .plus)
        #expect(negativeZero.sign == .minus)
    }
}
