// ReadmeVerificationTests.swift
// swift-ieee-754
//
// Verification tests for README code examples
// Ensures all README examples compile and work correctly

import Testing
@testable import IEEE_754

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("Quick Start example (lines 46-56)")
    func quickStartExample() throws {
        // Double to bytes
        let bytes = (3.14159).bytes()
        #expect(bytes.count == 8)

        // Bytes to Double
        let value = Double(bytes: bytes)
        #expect(value != nil)
        #expect(value! == 3.14159)
    }

    @Test("Basic Serialization example (lines 63-71)")
    func basicSerializationExample() throws {
        // Double serialization
        let value: Double = 3.141592653589793
        let bytes = value.bytes()

        // Double deserialization
        let restored = Double(bytes: bytes)
        #expect(restored == value)
    }

    @Test("Endianness Control example (lines 76-84)")
    func endiannessControlExample() throws {
        let value: Double = 3.14159

        // Little-endian (default)
        let littleEndian = value.bytes(endianness: .little)

        // Big-endian (network byte order)
        let bigEndian = value.bytes(endianness: .big)

        // Deserialize with matching endianness
        let restored = Double(bytes: bigEndian, endianness: .big)
        #expect(restored == value)
        #expect(littleEndian != bigEndian)
    }

    @Test("Float Operations example (lines 89-96)")
    func floatOperationsExample() throws {
        // Float serialization (binary32)
        let float: Float = 3.14159
        let bytes = float.bytes()
        #expect(bytes == [0xD0, 0x0F, 0x49, 0x40])

        // Float deserialization
        let restored = Float(bytes: bytes)
        #expect(restored == float)
    }

    @Test("Authoritative API example (lines 103-110)")
    func authoritativeAPIExample() throws {
        // Binary64 (Double)
        let bytes = IEEE_754.Binary64.bytes(from: 3.14159)
        let value = IEEE_754.Binary64.value(from: bytes)
        #expect(value == 3.14159)

        // Binary32 (Float)
        let floatBytes = IEEE_754.Binary32.bytes(from: Float(3.14))
        let floatValue = IEEE_754.Binary32.value(from: floatBytes)
        #expect(floatValue == Float(3.14))
    }

    @Test("Array Extensions example (lines 115-118)")
    func arrayExtensionsExample() throws {
        // Convenience initializers
        let doubleBytes: [UInt8] = [UInt8](3.14159)
        let floatBytes: [UInt8] = [UInt8](Float(3.14))

        #expect(doubleBytes.count == 8)
        #expect(floatBytes.count == 4)
    }

    @Test("Special Values example (lines 123-136)")
    func specialValuesExample() throws {
        // Infinity
        let inf = Double.infinity.bytes()
        let negInf = (-Double.infinity).bytes()
        #expect(inf.count == 8)
        #expect(negInf.count == 8)

        // NaN
        let nan = Double.nan.bytes()
        #expect(nan.count == 8)

        // Signed zero
        let posZero = (0.0).bytes()
        let negZero = (-0.0).bytes()
        #expect(posZero.count == 8)
        #expect(negZero.count == 8)
        #expect(posZero != negZero)  // Different bit patterns

        // Subnormal numbers
        let subnormal = Double.leastNonzeroMagnitude.bytes()
        #expect(subnormal.count == 8)
    }
}
