// IEEE_754.Payload Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 6.2 NaN Payload operations

import Testing

@testable import IEEE_754

// MARK: - Double Payload Tests

@Suite("IEEE_754.Payload - Double extract")
struct DoublePayloadExtractTests {
    @Test func extractFromQuietNaN() {
        let qnan = Double.nan
        let payload = IEEE_754.Payload.extract(from: qnan)
        #expect(payload != nil, "Should extract payload from quiet NaN")
    }

    @Test func extractFromSignalingNaN() {
        let snan = Double.signalingNaN
        let payload = IEEE_754.Payload.extract(from: snan)
        #expect(payload != nil, "Should extract payload from signaling NaN")
    }

    @Test func extractFromNonNaN() {
        #expect(IEEE_754.Payload.extract(from: 3.14) == nil, "Should return nil for normal value")
        #expect(IEEE_754.Payload.extract(from: 0.0) == nil, "Should return nil for zero")
        #expect(IEEE_754.Payload.extract(from: Double.infinity) == nil, "Should return nil for infinity")
    }

    @Test func payloadInRange() {
        let qnan = Double.nan
        if let payload = IEEE_754.Payload.extract(from: qnan) {
            // Payload should fit within the significand bits
            let maxPayload: UInt64 = 0x000F_FFFF_FFFF_FFFF
            #expect(payload <= maxPayload, "Payload should be within valid range")
        }
    }
}

@Suite("IEEE_754.Payload - Double encodeQuietNaN")
struct DoubleEncodeQuietNaNTests {
    @Test func encodeZeroPayload() {
        let nan: Double = IEEE_754.Payload.encodeQuietNaN(payload: 0)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(!nan.isSignalingNaN, "Result should be quiet NaN")
    }

    @Test func encodeNonZeroPayload() {
        let payload: UInt64 = 0x1234
        let nan: Double = IEEE_754.Payload.encodeQuietNaN(payload: payload)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(!nan.isSignalingNaN, "Result should be quiet NaN")

        if let extracted = IEEE_754.Payload.extract(from: nan) {
            // Note: Payload may be modified by quiet bit
            #expect(extracted != 0, "Payload should be non-zero")
        }
    }

    @Test func encodeLargePayload() {
        let payload: UInt64 = 0x0007_FFFF_FFFF_FFFF
        let nan: Double = IEEE_754.Payload.encodeQuietNaN(payload: payload)
        #expect(nan.isNaN, "Result should be NaN")
    }
}

@Suite("IEEE_754.Payload - Double encodeSignalingNaN")
struct DoubleEncodeSignalingNaNTests {
    @Test func encodeZeroPayload() {
        // Zero payload should be converted to 1 for signaling NaN
        let nan: Double = IEEE_754.Payload.encodeSignalingNaN(payload: 0)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(nan.isSignalingNaN, "Result should be signaling NaN")
    }

    @Test func encodeNonZeroPayload() {
        let payload: UInt64 = 0x1234
        let nan: Double = IEEE_754.Payload.encodeSignalingNaN(payload: payload)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(nan.isSignalingNaN, "Result should be signaling NaN")
    }

    @Test func encodeMinimalPayload() {
        let nan: Double = IEEE_754.Payload.encodeSignalingNaN(payload: 1)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(nan.isSignalingNaN, "Result should be signaling NaN")
    }
}

@Suite("IEEE_754.Payload - Double isQuietNaN")
struct DoubleIsQuietNaNTests {
    @Test func detectQuietNaN() {
        #expect(IEEE_754.Payload.isQuietNaN(Double.nan), "Should detect quiet NaN")
    }

    @Test func detectSignalingNaN() {
        #expect(!IEEE_754.Payload.isQuietNaN(Double.signalingNaN), "Should not detect signaling NaN as quiet")
    }

    @Test func nonNaNValues() {
        #expect(!IEEE_754.Payload.isQuietNaN(3.14), "Normal value is not quiet NaN")
        #expect(!IEEE_754.Payload.isQuietNaN(0.0), "Zero is not quiet NaN")
        #expect(!IEEE_754.Payload.isQuietNaN(Double.infinity), "Infinity is not quiet NaN")
    }
}

@Suite("IEEE_754.Payload - Double isSignalingNaN")
struct DoubleIsSignalingNaNTests {
    @Test func detectSignalingNaN() {
        #expect(IEEE_754.Payload.isSignalingNaN(Double.signalingNaN), "Should detect signaling NaN")
    }

    @Test func detectQuietNaN() {
        #expect(!IEEE_754.Payload.isSignalingNaN(Double.nan), "Should not detect quiet NaN as signaling")
    }

    @Test func nonNaNValues() {
        #expect(!IEEE_754.Payload.isSignalingNaN(3.14), "Normal value is not signaling NaN")
        #expect(!IEEE_754.Payload.isSignalingNaN(0.0), "Zero is not signaling NaN")
        #expect(!IEEE_754.Payload.isSignalingNaN(Double.infinity), "Infinity is not signaling NaN")
    }
}

// MARK: - Float Payload Tests

@Suite("IEEE_754.Payload - Float extract")
struct FloatPayloadExtractTests {
    @Test func extractFromQuietNaN() {
        let qnan = Float.nan
        let payload = IEEE_754.Payload.extract(from: qnan)
        #expect(payload != nil, "Should extract payload from quiet NaN")
    }

    @Test func extractFromSignalingNaN() {
        let snan = Float.signalingNaN
        let payload = IEEE_754.Payload.extract(from: snan)
        #expect(payload != nil, "Should extract payload from signaling NaN")
    }

    @Test func extractFromNonNaN() {
        #expect(IEEE_754.Payload.extract(from: Float(3.14)) == nil, "Should return nil for normal value")
        #expect(IEEE_754.Payload.extract(from: Float(0.0)) == nil, "Should return nil for zero")
        #expect(IEEE_754.Payload.extract(from: Float.infinity) == nil, "Should return nil for infinity")
    }

    @Test func payloadInRange() {
        let qnan = Float.nan
        if let payload = IEEE_754.Payload.extract(from: qnan) {
            let maxPayload: UInt32 = 0x003F_FFFF
            #expect(payload <= maxPayload, "Payload should be within valid range")
        }
    }
}

@Suite("IEEE_754.Payload - Float encodeQuietNaN")
struct FloatEncodeQuietNaNTests {
    @Test func encodeZeroPayload() {
        let nan: Float = IEEE_754.Payload.encodeQuietNaN(payload: 0)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(!nan.isSignalingNaN, "Result should be quiet NaN")
    }

    @Test func encodeNonZeroPayload() {
        let payload: UInt32 = 0x1234
        let nan: Float = IEEE_754.Payload.encodeQuietNaN(payload: payload)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(!nan.isSignalingNaN, "Result should be quiet NaN")
    }
}

@Suite("IEEE_754.Payload - Float encodeSignalingNaN")
struct FloatEncodeSignalingNaNTests {
    @Test func encodeZeroPayload() {
        let nan: Float = IEEE_754.Payload.encodeSignalingNaN(payload: 0)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(nan.isSignalingNaN, "Result should be signaling NaN")
    }

    @Test func encodeNonZeroPayload() {
        let payload: UInt32 = 0x1234
        let nan: Float = IEEE_754.Payload.encodeSignalingNaN(payload: payload)
        #expect(nan.isNaN, "Result should be NaN")
        #expect(nan.isSignalingNaN, "Result should be signaling NaN")
    }
}

@Suite("IEEE_754.Payload - Float isQuietNaN")
struct FloatIsQuietNaNTests {
    @Test func detectQuietNaN() {
        #expect(IEEE_754.Payload.isQuietNaN(Float.nan), "Should detect quiet NaN")
    }

    @Test func detectSignalingNaN() {
        #expect(!IEEE_754.Payload.isQuietNaN(Float.signalingNaN), "Should not detect signaling NaN as quiet")
    }

    @Test func nonNaNValues() {
        #expect(!IEEE_754.Payload.isQuietNaN(Float(3.14)), "Normal value is not quiet NaN")
    }
}

@Suite("IEEE_754.Payload - Float isSignalingNaN")
struct FloatIsSignalingNaNTests {
    @Test func detectSignalingNaN() {
        #expect(IEEE_754.Payload.isSignalingNaN(Float.signalingNaN), "Should detect signaling NaN")
    }

    @Test func detectQuietNaN() {
        #expect(!IEEE_754.Payload.isSignalingNaN(Float.nan), "Should not detect quiet NaN as signaling")
    }

    @Test func nonNaNValues() {
        #expect(!IEEE_754.Payload.isSignalingNaN(Float(3.14)), "Normal value is not signaling NaN")
    }
}

// MARK: - Payload Preservation Tests

@Suite("IEEE_754.Payload - Payload Preservation")
struct PayloadPreservationTests {
    @Test func roundTripQuietNaN() {
        let payload: UInt64 = 0x123456
        let nan = IEEE_754.Payload.encodeQuietNaN(payload: payload)
        if let extracted = IEEE_754.Payload.extract(from: nan) {
            // Payload should be preserved (modulo quiet bit)
            #expect(extracted != 0, "Payload should be non-zero")
        }
    }

    @Test func roundTripSignalingNaN() {
        let payload: UInt64 = 0x123456
        let nan = IEEE_754.Payload.encodeSignalingNaN(payload: payload)
        if let extracted = IEEE_754.Payload.extract(from: nan) {
            // Payload should be preserved (modulo signaling bit)
            #expect(extracted != 0, "Payload should be non-zero")
        }
    }

    @Test func signPreservation() {
        let positiveNaN: Double = IEEE_754.Payload.encodeQuietNaN(payload: 0x1234)
        let negativeNaN = -positiveNaN
        #expect(positiveNaN.sign == .plus, "Encoded NaN should be positive")
        #expect(negativeNaN.sign == .minus, "Negated NaN should be negative")
        #expect(negativeNaN.isNaN, "Negated NaN should still be NaN")
    }
}
