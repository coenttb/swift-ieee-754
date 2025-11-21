// [Double] Tests.swift
// swift-ieee-754
//
// Tests for [Double] array extensions

import Testing
@testable import IEEE_754

@Suite("Array<Double> - Deserialization")
struct DoubleArrayTests {

    @Test("Single Double from 8 bytes")
    func singleDouble() {
        let bytes: [UInt8] = [0x6E, 0x86, 0x1B, 0xF0, 0xF9, 0x21, 0x09, 0x40]
        let doubles = [Double](bytes: bytes)
        #expect(doubles != nil)
        #expect(doubles?.count == 1)
        #expect(doubles?[0] == 3.14159)
    }

    @Test("Multiple Doubles from bytes")
    func multipleDoubles() {
        let bytes: [UInt8] = [
            0x6E, 0x86, 0x1B, 0xF0, 0xF9, 0x21, 0x09, 0x40,  // 3.14159
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F,  // 1.0
            0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40   // 2.0
        ]
        let doubles = [Double](bytes: bytes)
        #expect(doubles != nil)
        #expect(doubles?.count == 3)
        #expect(doubles?[0] == 3.14159)
        #expect(doubles?[1] == 1.0)
        #expect(doubles?[2] == 2.0)
    }

    @Test("Empty bytes returns empty array")
    func emptyBytes() {
        let bytes: [UInt8] = []
        let doubles = [Double](bytes: bytes)
        #expect(doubles != nil)
        #expect(doubles?.isEmpty == true)
    }

    @Test("Invalid byte count returns nil")
    func invalidByteCount() {
        // 7 bytes - not a multiple of 8
        let bytes: [UInt8] = [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07]
        let doubles = [Double](bytes: bytes)
        #expect(doubles == nil)
    }

    @Test("Big-endian deserialization")
    func bigEndian() {
        let bytes: [UInt8] = [
            0x40, 0x09, 0x21, 0xFB, 0x54, 0x44, 0x2D, 0x18,  // 3.141592653589793 (big-endian)
            0x3F, 0xF0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   // 1.0 (big-endian)
        ]
        let doubles = [Double](bytes: bytes, endianness: .big)
        #expect(doubles != nil)
        #expect(doubles?.count == 2)
        #expect(doubles?[0] == 3.141592653589793)
        #expect(doubles?[1] == 1.0)
    }

    @Test("Special values - infinity and NaN")
    func specialValues() {
        let infBytes = Double.infinity.bytes()
        let negInfBytes = (-Double.infinity).bytes()
        let nanBytes = Double.nan.bytes()

        let bytes = infBytes + negInfBytes + nanBytes
        let doubles = [Double](bytes: bytes)

        #expect(doubles != nil)
        #expect(doubles?.count == 3)
        #expect(doubles?[0] == .infinity)
        #expect(doubles?[1] == -.infinity)
        #expect(doubles?[2].isNaN == true)
    }

    @Test("Special values - signed zero")
    func signedZero() {
        let posZeroBytes = (0.0 as Double).bytes()
        let negZeroBytes = (-0.0 as Double).bytes()

        let bytes = posZeroBytes + negZeroBytes
        let doubles = [Double](bytes: bytes)

        #expect(doubles != nil)
        #expect(doubles?.count == 2)
        #expect(doubles?[0] == 0.0)
        #expect(doubles?[1] == -0.0)

        // Verify sign bit is preserved
        #expect(doubles?[0].sign == .plus)
        #expect(doubles?[1].sign == .minus)
    }

    @Test("Large array of Doubles")
    func largeArray() {
        let count = 1000
        let originalDoubles = (0..<count).map { Double($0) }

        var allBytes: [UInt8] = []
        for double in originalDoubles {
            allBytes += double.bytes()
        }

        let deserializedDoubles = [Double](bytes: allBytes)
        #expect(deserializedDoubles != nil)
        #expect(deserializedDoubles?.count == count)
        #expect(deserializedDoubles == originalDoubles)
    }

    @Test("Round-trip through array serialization")
    func roundTrip() {
        let original: [Double] = [3.14159, 2.71828, 1.41421, 1.61803]

        var bytes: [UInt8] = []
        for double in original {
            bytes += double.bytes()
        }

        let roundtripped = [Double](bytes: bytes)
        #expect(roundtripped != nil)
        #expect(roundtripped == original)
    }
}
