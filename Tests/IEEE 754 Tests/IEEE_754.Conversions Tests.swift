// IEEE_754.Conversions Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.4 Conversion operations

import Testing

@testable import IEEE_754

// MARK: - Format Conversions

@Suite("IEEE_754.Conversions - Float to Double")
struct FloatToDoubleTests {
    @Test(arguments: [Float(3.14), Float(-3.14), Float(0.0), Float(-0.0), Float(1.0), Float(100.0)])
    func exactConversion(value: Float) {
        let result = IEEE_754.Conversions.floatToDouble(value)
        #expect(Double(value) == result, "Conversion should be exact")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.floatToDouble(Float.infinity) == Double.infinity)
        #expect(IEEE_754.Conversions.floatToDouble(-Float.infinity) == -Double.infinity)
        #expect(IEEE_754.Conversions.floatToDouble(Float.nan).isNaN)
        #expect(IEEE_754.Conversions.floatToDouble(Float.signalingNaN).isNaN)
    }

    @Test func extremeValues() {
        let maxFloat = Float.greatestFiniteMagnitude
        let result = IEEE_754.Conversions.floatToDouble(maxFloat)
        #expect(result.isFinite, "Max Float should convert to finite Double")
        #expect(result == Double(maxFloat), "Conversion should be exact")
    }

    @Test func subnormals() {
        let subnorm = Float.leastNonzeroMagnitude
        let result = IEEE_754.Conversions.floatToDouble(subnorm)
        #expect(result == Double(subnorm), "Subnormal should convert exactly")
    }
}

@Suite("IEEE_754.Conversions - Double to Float")
struct DoubleToFloatTests {
    @Test(arguments: [1.0, -1.0, 3.14, -2.71, 0.0, -0.0])
    func normalValues(value: Double) {
        let result = IEEE_754.Conversions.doubleToFloat(value)
        #expect(result == Float(value), "Conversion should match Swift's conversion")
    }

    @Test func overflow() {
        let huge = 1e308  // Much larger than Float max
        let result = IEEE_754.Conversions.doubleToFloat(huge)
        #expect(result.isInfinite, "Overflow should produce infinity")
        #expect(result.sign == .plus, "Sign should be preserved")
    }

    @Test func underflow() {
        let tiny = 1e-50  // Much smaller than Float min
        let result = IEEE_754.Conversions.doubleToFloat(tiny)
        #expect(result == 0.0 || result.isSubnormal, "Underflow should produce zero or subnormal")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.doubleToFloat(Double.infinity) == Float.infinity)
        #expect(IEEE_754.Conversions.doubleToFloat(-Double.infinity) == -Float.infinity)
        #expect(IEEE_754.Conversions.doubleToFloat(Double.nan).isNaN)
    }

    @Test func rounding() {
        // Value that requires rounding when converting to Float
        let value = 1.00000000000000001  // More precision than Float can hold
        let result = IEEE_754.Conversions.doubleToFloat(value)
        #expect(result == Float(value), "Should round appropriately")
    }

    @Test func signedZeros() {
        #expect(IEEE_754.Conversions.doubleToFloat(0.0).sign == .plus)
        #expect(IEEE_754.Conversions.doubleToFloat(-0.0).sign == .minus)
    }
}

// MARK: - Integer Conversions

@Suite("IEEE_754.Conversions - Double to Int")
struct DoubleToIntTests {
    @Test(arguments: [(3.14, 3), (3.5, 4), (4.5, 4), (-3.5, -4)])
    func tiesToEven(value: Double, expected: Int) {
        let result = IEEE_754.Conversions.doubleToInt(value)
        #expect(result == expected, "doubleToInt(\(value)) should be \(expected)")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.doubleToInt(Double.nan) == nil, "NaN should return nil")
        #expect(IEEE_754.Conversions.doubleToInt(Double.infinity) == nil, "Infinity should return nil")
        #expect(IEEE_754.Conversions.doubleToInt(-Double.infinity) == nil, "-Infinity should return nil")
    }

    @Test func exactValues() {
        #expect(IEEE_754.Conversions.doubleToInt(0.0) == 0)
        #expect(IEEE_754.Conversions.doubleToInt(1.0) == 1)
        #expect(IEEE_754.Conversions.doubleToInt(-1.0) == -1)
        #expect(IEEE_754.Conversions.doubleToInt(42.0) == 42)
    }

    @Test func outOfRange() {
        let tooLarge = Double(Int.max) + 1.0e10
        let tooSmall = Double(Int.min) - 1.0e10
        #expect(IEEE_754.Conversions.doubleToInt(tooLarge) == nil, "Out of range should return nil")
        #expect(IEEE_754.Conversions.doubleToInt(tooSmall) == nil, "Out of range should return nil")
    }
}

@Suite("IEEE_754.Conversions - Double to Int Truncating")
struct DoubleToIntTruncatingTests {
    @Test(arguments: [(3.9, 3), (-3.9, -3), (3.1, 3), (-3.1, -3)])
    func truncation(value: Double, expected: Int) {
        let result = IEEE_754.Conversions.doubleToIntTruncating(value)
        #expect(result == expected, "doubleToIntTruncating(\(value)) should be \(expected)")
    }

    @Test func exactValues() {
        #expect(IEEE_754.Conversions.doubleToIntTruncating(0.0) == 0)
        #expect(IEEE_754.Conversions.doubleToIntTruncating(42.0) == 42)
        #expect(IEEE_754.Conversions.doubleToIntTruncating(-42.0) == -42)
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.doubleToIntTruncating(Double.nan) == nil)
        #expect(IEEE_754.Conversions.doubleToIntTruncating(Double.infinity) == nil)
    }
}

@Suite("IEEE_754.Conversions - Int to Double")
struct IntToDoubleTests {
    @Test(arguments: [0, 1, -1, 42, -42, 1000, -1000])
    func smallIntegers(value: Int) {
        let result = IEEE_754.Conversions.intToDouble(value)
        #expect(result == Double(value), "Conversion should be exact for small integers")
        #expect(Int(result) == value, "Should round-trip exactly")
    }

    @Test func largeIntegers() {
        let large = Int(1_000_000_000_000_000)
        let result = IEEE_754.Conversions.intToDouble(large)
        #expect(result == Double(large), "Conversion should match Swift's conversion")
    }

    @Test func extremeValues() {
        #expect(IEEE_754.Conversions.intToDouble(Int.max) == Double(Int.max))
        #expect(IEEE_754.Conversions.intToDouble(Int.min) == Double(Int.min))
    }
}

@Suite("IEEE_754.Conversions - Float to Int")
struct FloatToIntTests {
    @Test(arguments: [(Float(3.14), 3), (Float(3.5), 4), (Float(4.5), 4)])
    func tiesToEven(value: Float, expected: Int) {
        let result = IEEE_754.Conversions.floatToInt(value)
        #expect(result == expected)
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.floatToInt(Float.nan) == nil)
        #expect(IEEE_754.Conversions.floatToInt(Float.infinity) == nil)
    }
}

@Suite("IEEE_754.Conversions - Float to Int Truncating")
struct FloatToIntTruncatingTests {
    @Test(arguments: [(Float(3.9), 3), (Float(-3.9), -3)])
    func truncation(value: Float, expected: Int) {
        let result = IEEE_754.Conversions.floatToIntTruncating(value)
        #expect(result == expected)
    }
}

@Suite("IEEE_754.Conversions - Int to Float")
struct IntToFloatTests {
    @Test(arguments: [0, 1, -1, 42, -42])
    func smallIntegers(value: Int) {
        let result = IEEE_754.Conversions.intToFloat(value)
        #expect(result == Float(value))
    }

    @Test func largeIntegers() {
        let large = 16_777_217  // 2^24 + 1, cannot be exactly represented in Float
        let result = IEEE_754.Conversions.intToFloat(large)
        #expect(result == Float(large), "Should match Swift's conversion (with rounding)")
    }
}

// MARK: - Unsigned Integer Conversions

@Suite("IEEE_754.Conversions - Double to UInt")
struct DoubleToUIntTests {
    @Test(arguments: [(3.14, UInt(3)), (3.5, UInt(4)), (0.0, UInt(0))])
    func positiveValues(value: Double, expected: UInt) {
        let result = IEEE_754.Conversions.doubleToUInt(value)
        #expect(result == expected)
    }

    @Test func negativeValues() {
        #expect(IEEE_754.Conversions.doubleToUInt(-1.0) == nil, "Negative should return nil")
        #expect(IEEE_754.Conversions.doubleToUInt(-0.0) != nil, "-0.0 should convert to 0")
    }

    @Test func specialValues() {
        #expect(IEEE_754.Conversions.doubleToUInt(Double.nan) == nil)
        #expect(IEEE_754.Conversions.doubleToUInt(Double.infinity) == nil)
    }
}

@Suite("IEEE_754.Conversions - UInt to Double")
struct UIntToDoubleTests {
    @Test(arguments: [UInt(0), UInt(1), UInt(42), UInt(1000)])
    func normalValues(value: UInt) {
        let result = IEEE_754.Conversions.uintToDouble(value)
        #expect(result == Double(value))
    }

    @Test func largeValues() {
        let large = UInt.max
        let result = IEEE_754.Conversions.uintToDouble(large)
        #expect(result == Double(large))
    }
}

@Suite("IEEE_754.Conversions - Float to UInt")
struct FloatToUIntTests {
    @Test(arguments: [(Float(3.14), UInt(3)), (Float(0.0), UInt(0))])
    func positiveValues(value: Float, expected: UInt) {
        let result = IEEE_754.Conversions.floatToUInt(value)
        #expect(result == expected)
    }

    @Test func negativeValues() {
        #expect(IEEE_754.Conversions.floatToUInt(Float(-1.0)) == nil)
    }
}

@Suite("IEEE_754.Conversions - UInt to Float")
struct UIntToFloatTests {
    @Test(arguments: [UInt(0), UInt(1), UInt(42)])
    func normalValues(value: UInt) {
        let result = IEEE_754.Conversions.uintToFloat(value)
        #expect(result == Float(value))
    }
}

// MARK: - Round-trip Tests

@Suite("IEEE_754.Conversions - Round-trip Tests")
struct ConversionRoundTripTests {
    @Test(arguments: [Float(0.0), Float(1.0), Float(3.14), Float(-2.71)])
    func floatDoubleFloatRoundTrip(value: Float) {
        let asDouble = IEEE_754.Conversions.floatToDouble(value)
        let backToFloat = IEEE_754.Conversions.doubleToFloat(asDouble)
        if value.isNaN {
            #expect(backToFloat.isNaN, "NaN should round-trip")
        } else if value.isZero {
            #expect(backToFloat.isZero && backToFloat.sign == value.sign, "Signed zero should round-trip")
        } else {
            #expect(backToFloat == value, "Float → Double → Float should preserve value")
        }
    }

    @Test(arguments: [0, 1, -1, 42, -42, 1000])
    func intDoubleIntRoundTrip(value: Int) {
        let asDouble = IEEE_754.Conversions.intToDouble(value)
        let backToInt = IEEE_754.Conversions.doubleToIntTruncating(asDouble)
        #expect(backToInt == value, "Int → Double → Int should preserve value for small integers")
    }
}
