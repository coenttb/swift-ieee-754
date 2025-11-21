// [Float] Tests.swift
// swift-ieee-754
//
// Tests for [Float] array extensions

import Testing
@testable import IEEE_754

@Suite("Array<Float> - Deserialization")
struct FloatArrayTests {

    @Test("Single Float from 4 bytes")
    func singleFloat() {
        let bytes: [UInt8] = [0xD0, 0x0F, 0x49, 0x40]
        let floats = [Float](bytes: bytes)
        #expect(floats != nil)
        #expect(floats?.count == 1)
        #expect(floats?[0] == 3.14159)
    }

    @Test("Multiple Floats from bytes")
    func multipleFloats() {
        let bytes: [UInt8] = [
            0xD0, 0x0F, 0x49, 0x40,  // 3.14159
            0x00, 0x00, 0x80, 0x3F,  // 1.0
            0x00, 0x00, 0x00, 0x40   // 2.0
        ]
        let floats = [Float](bytes: bytes)
        #expect(floats != nil)
        #expect(floats?.count == 3)
        #expect(floats?[0] == 3.14159)
        #expect(floats?[1] == 1.0)
        #expect(floats?[2] == 2.0)
    }

    @Test("Empty bytes returns empty array")
    func emptyBytes() {
        let bytes: [UInt8] = []
        let floats = [Float](bytes: bytes)
        #expect(floats != nil)
        #expect(floats?.isEmpty == true)
    }

    @Test("Invalid byte count returns nil")
    func invalidByteCount() {
        // 3 bytes - not a multiple of 4
        let bytes: [UInt8] = [0x01, 0x02, 0x03]
        let floats = [Float](bytes: bytes)
        #expect(floats == nil)
    }

    @Test("Big-endian deserialization")
    func bigEndian() {
        let bytes: [UInt8] = [
            0x40, 0x49, 0x0F, 0xD0,  // 3.14159 (big-endian)
            0x3F, 0x80, 0x00, 0x00   // 1.0 (big-endian)
        ]
        let floats = [Float](bytes: bytes, endianness: .big)
        #expect(floats != nil)
        #expect(floats?.count == 2)
        #expect(floats?[0] == 3.14159)
        #expect(floats?[1] == 1.0)
    }

    @Test("Special values - infinity and NaN")
    func specialValues() {
        let infBytes = Float.infinity.bytes()
        let negInfBytes = (-Float.infinity).bytes()
        let nanBytes = Float.nan.bytes()

        let bytes = infBytes + negInfBytes + nanBytes
        let floats = [Float](bytes: bytes)

        #expect(floats != nil)
        #expect(floats?.count == 3)
        #expect(floats?[0] == .infinity)
        #expect(floats?[1] == -.infinity)
        #expect(floats?[2].isNaN == true)
    }

    @Test("Special values - signed zero")
    func signedZero() {
        let posZeroBytes = (0.0 as Float).bytes()
        let negZeroBytes = (-0.0 as Float).bytes()

        let bytes = posZeroBytes + negZeroBytes
        let floats = [Float](bytes: bytes)

        #expect(floats != nil)
        #expect(floats?.count == 2)
        #expect(floats?[0] == 0.0)
        #expect(floats?[1] == -0.0)

        // Verify sign bit is preserved
        #expect(floats?[0].sign == .plus)
        #expect(floats?[1].sign == .minus)
    }

    @Test("Large array of Floats")
    func largeArray() {
        let count = 1000
        let originalFloats = (0..<count).map { Float($0) }

        var allBytes: [UInt8] = []
        for float in originalFloats {
            allBytes += float.bytes()
        }

        let deserializedFloats = [Float](bytes: allBytes)
        #expect(deserializedFloats != nil)
        #expect(deserializedFloats?.count == count)
        #expect(deserializedFloats == originalFloats)
    }

    @Test("Round-trip through array serialization")
    func roundTrip() {
        let original: [Float] = [3.14159, 2.71828, 1.41421, 1.61803]

        var bytes: [UInt8] = []
        for float in original {
            bytes += float.bytes()
        }

        let roundtripped = [Float](bytes: bytes)
        #expect(roundtripped != nil)
        #expect(roundtripped == original)
    }

    @Test("Mixed positive and negative values")
    func mixedValues() {
        let original: [Float] = [-100.5, 0.0, 100.5, -0.0, Float.infinity, -Float.infinity]

        var bytes: [UInt8] = []
        for float in original {
            bytes += float.bytes()
        }

        let deserialized = [Float](bytes: bytes)
        #expect(deserialized != nil)
        #expect(deserialized?.count == 6)

        if let deserialized = deserialized {
            #expect(deserialized[0] == -100.5)
            #expect(deserialized[1] == 0.0)
            #expect(deserialized[2] == 100.5)
            #expect(deserialized[3] == -0.0)
            #expect(deserialized[4] == .infinity)
            #expect(deserialized[5] == -.infinity)
        }
    }
}
