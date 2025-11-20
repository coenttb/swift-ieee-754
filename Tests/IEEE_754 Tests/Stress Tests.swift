// Stress Tests.swift
// swift-ieee-754
//
// Performance and stress tests for IEEE 754 implementation
// Tests scalability, consistency under load, and performance characteristics

import StandardsTestSupport
import Testing

@testable import IEEE_754

// MARK: - Double Performance Tests

extension `Performance Tests` {
    @Suite
    struct `Double - Performance` {
        @Test(.timed(threshold: .milliseconds(20)))
        func `serialize 10000 random doubles`() {
            for _ in 0..<10_000 {
                let value = Double.random(in: -1e100...1e100)
                _ = value.bytes()
            }
        }

        @Test(.timed(threshold: .milliseconds(70)))
        func `round-trip 10000 random doubles`() {
            for _ in 0..<10_000 {
                let original = Double.random(in: -1e100...1e100)
                let bytes = original.bytes()
                _ = Double(bytes: bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(70)))
        func `serialize mixed special and normal values 10000 times`() {
            let specialValues: [Double] = [
                0.0, -0.0,
                .infinity, -.infinity,
                .leastNonzeroMagnitude, -.leastNonzeroMagnitude,
                .leastNormalMagnitude, -.leastNormalMagnitude,
                .greatestFiniteMagnitude, -.greatestFiniteMagnitude,
            ]

            var allValues: [Double] = specialValues

            // Add 9990 random values
            for _ in 0..<9_990 {
                allValues.append(Double.random(in: -1e200...1e200))
            }

            for value in allValues {
                let bytes = value.bytes()
                _ = Double(bytes: bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(8)))
        func `rapid back-and-forth conversions 1000 times`() {
            let original: Double = 3.141592653589793

            var current = original
            for _ in 0..<1_000 {
                let bytes = current.bytes()
                current = Double(bytes: bytes)!
            }

            #expect(current == original, "Value should remain stable")
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `all API paths 100 times`() {
            let original: Double = 2.718281828459045

            // Path 1: Direct bytes()
            for _ in 0..<100 {
                _ = original.bytes()
            }

            // Path 2: Namespace bytes()
            for _ in 0..<100 {
                _ = original.ieee754.bytes()
            }

            // Path 3: [UInt8] init
            for _ in 0..<100 {
                _ = [UInt8](original)
            }

            // Path 4: Type method
            for _ in 0..<100 {
                let bytes = original.bytes()
                _ = Double.ieee754(bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(3)))
        func `alternating endianness 100 times`() {
            let original: Double = 1.41421356237309504880

            for i in 0..<100 {
                let endianness: [UInt8].Endianness = i % 2 == 0 ? .little : .big
                let bytes = original.bytes(endianness: endianness)
                _ = Double(bytes: bytes, endianness: endianness)
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `sweep entire magnitude range`() {
            let magnitudes: [Double] = [
                1e-308, 1e-200, 1e-100, 1e-50, 1e-10,
                1e-5, 1e-2, 1.0, 1e2, 1e5,
                1e10, 1e50, 1e100, 1e200, 1e308,
            ]

            for _ in 0..<100 {
                for magnitude in magnitudes {
                    _ = magnitude.bytes()
                    _ = (-magnitude).bytes()
                }
            }
        }
    }
}

// MARK: - Float Performance Tests

extension `Performance Tests` {
    @Suite
    struct `Float - Performance` {
        @Test(.timed(threshold: .milliseconds(20)))
        func `serialize 10000 random floats`() {
            for _ in 0..<10_000 {
                let value = Float.random(in: -1e30...1e30)
                _ = value.bytes()
            }
        }

        @Test(.timed(threshold: .milliseconds(20)))
        func `round-trip 10000 random floats`() {
            for _ in 0..<10_000 {
                let original = Float.random(in: -1e30...1e30)
                let bytes = original.bytes()
                _ = Float(bytes: bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `rapid back-and-forth conversions 1000 times`() {
            let original: Float = 3.14159

            var current = original
            for _ in 0..<1_000 {
                let bytes = current.bytes()
                current = Float(bytes: bytes)!
            }

            #expect(current == original, "Value should remain stable")
        }

        @Test(.timed(threshold: .milliseconds(1)))
        func `alternating endianness 100 times`() {
            let original: Float = 2.71828

            for i in 0..<100 {
                let endianness: [UInt8].Endianness = i % 2 == 0 ? .little : .big
                let bytes = original.bytes(endianness: endianness)
                _ = Float(bytes: bytes, endianness: endianness)
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `sweep entire magnitude range`() {
            let magnitudes: [Float] = [
                1e-38, 1e-30, 1e-20, 1e-10,
                1e-5, 1.0, 1e5, 1e10,
                1e20, 1e30, 1e38,
            ]

            for _ in 0..<100 {
                for magnitude in magnitudes {
                    _ = magnitude.bytes()
                    _ = (-magnitude).bytes()
                }
            }
        }
    }
}

// MARK: - Binary64 Authoritative Performance

extension `Performance Tests` {
    @Suite
    struct `Binary64 - Performance` {
        @Test(.timed(threshold: .milliseconds(20)))
        func `serialize 10000 doubles via Binary64`() {
            for _ in 0..<10_000 {
                let value = Double.random(in: -1e100...1e100)
                _ = IEEE_754.Binary64.bytes(from: value)
            }
        }

        @Test(.timed(threshold: .milliseconds(25)))
        func `deserialize 10000 byte arrays via Binary64`() {
            // Pre-generate byte arrays
            var byteArrays: [[UInt8]] = []
            for _ in 0..<10_000 {
                let value = Double.random(in: -1e100...1e100)
                byteArrays.append(IEEE_754.Binary64.bytes(from: value))
            }

            // Measure deserialization
            for bytes in byteArrays {
                _ = IEEE_754.Binary64.value(from: bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `both endianness 1000 times`() {
            let value: Double = 3.14159265358979323846

            for _ in 0..<1_000 {
                _ = IEEE_754.Binary64.bytes(from: value, endianness: .little)
                _ = IEEE_754.Binary64.bytes(from: value, endianness: .big)
            }
        }
    }
}

// MARK: - Binary32 Authoritative Performance

extension `Performance Tests` {
    @Suite
    struct `Binary32 - Performance` {
        @Test(.timed(threshold: .milliseconds(18)))
        func `serialize 10000 floats via Binary32`() {
            for _ in 0..<10_000 {
                let value = Float.random(in: -1e30...1e30)
                _ = IEEE_754.Binary32.bytes(from: value)
            }
        }

        @Test(.timed(threshold: .milliseconds(22)))
        func `deserialize 10000 byte arrays via Binary32`() {
            var byteArrays: [[UInt8]] = []
            for _ in 0..<10_000 {
                let value = Float.random(in: -1e30...1e30)
                byteArrays.append(IEEE_754.Binary32.bytes(from: value))
            }

            for bytes in byteArrays {
                _ = IEEE_754.Binary32.value(from: bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `both endianness 1000 times`() {
            let value: Float = 3.14159

            for _ in 0..<1_000 {
                _ = IEEE_754.Binary32.bytes(from: value, endianness: .little)
                _ = IEEE_754.Binary32.bytes(from: value, endianness: .big)
            }
        }
    }
}

// MARK: - Bit Pattern Stress Tests

extension `Performance Tests` {
    @Suite
    struct `Bit Patterns - Performance` {
        @Test(.timed(threshold: .milliseconds(3)))
        func `all 256 byte values in each Double position`() {
            for position in 0..<8 {
                for byteValue in UInt8.min...UInt8.max {
                    var bytes: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
                    bytes[position] = byteValue
                    _ = Double(bytes: bytes)
                }
            }
        }

        @Test(.timed(threshold: .milliseconds(2)))
        func `all 256 byte values in each Float position`() {
            for position in 0..<4 {
                for byteValue in UInt8.min...UInt8.max {
                    var bytes: [UInt8] = [0x00, 0x00, 0x00, 0x00]
                    bytes[position] = byteValue
                    _ = Float(bytes: bytes)
                }
            }
        }
    }
}

// MARK: - Memory Efficiency Tests

extension `Performance Tests` {
    @Suite
    struct `Memory - Performance` {
        @Test(.timed(threshold: .milliseconds(12)))
        func `Double serialization does not leak memory`() {
            let value: Double = 3.14159265358979323846

            for _ in 0..<10_000 {
                _ = value.bytes()
                _ = value.ieee754.bytes()
                _ = [UInt8](value)
            }
        }

        @Test(.timed(threshold: .milliseconds(7)))
        func `Double deserialization does not leak memory`() {
            let bytes: [UInt8] = [0x18, 0x2D, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40]

            for _ in 0..<10_000 {
                _ = Double(bytes: bytes)
                _ = Double.ieee754(bytes)
            }
        }

        @Test(.timed(threshold: .milliseconds(12)))
        func `Float serialization does not leak memory`() {
            let value: Float = 3.14159

            for _ in 0..<10_000 {
                _ = value.bytes()
                _ = value.ieee754.bytes()
                _ = [UInt8](value)
            }
        }

        @Test(.timed(threshold: .milliseconds(7)))
        func `Float deserialization does not leak memory`() {
            let bytes: [UInt8] = [0xD0, 0x0F, 0x49, 0x40]

            for _ in 0..<10_000 {
                _ = Float(bytes: bytes)
                _ = Float.ieee754(bytes)
            }
        }
    }
}

// MARK: - Concurrent Access Consistency Tests (kept separate, not performance)

@Suite("IEEE 754 - Concurrent Access Consistency")
struct ConcurrentAccessTests {
    @Test func `concurrent serialization of same value`() async {
        let value: Double = 3.141592653589793
        let expectedBytes = value.bytes()

        await withTaskGroup(of: [UInt8].self) { group in
            for _ in 0..<100 {
                group.addTask {
                    value.bytes()
                }
            }

            var allMatch = true
            for await bytes in group {
                if bytes != expectedBytes {
                    allMatch = false
                }
            }

            #expect(allMatch, "All concurrent serializations should produce identical bytes")
        }
    }

    @Test func `concurrent deserialization of same bytes`() async {
        let bytes: [UInt8] = [0x18, 0x2D, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40]
        let expectedValue = Double(bytes: bytes)

        await withTaskGroup(of: Double?.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    Double(bytes: bytes)
                }
            }

            var allMatch = true
            for await value in group {
                if value != expectedValue {
                    allMatch = false
                }
            }

            #expect(allMatch, "All concurrent deserializations should produce identical values")
        }
    }
}

// MARK: - Determinism Tests (kept separate, not performance)

@Suite("IEEE 754 - Deterministic Behavior")
struct DeterminismTests {
    @Test func `repeated serialization produces identical results`() {
        let value: Double = 2.718281828459045

        let firstBytes = value.bytes()

        for _ in 0..<100 {
            let bytes = value.bytes()
            #expect(bytes == firstBytes, "Repeated serialization should be deterministic")
        }
    }

    @Test func `repeated deserialization produces identical results`() {
        let bytes: [UInt8] = [0x18, 0x2D, 0x44, 0x54, 0xFB, 0x21, 0x09, 0x40]

        let firstValue = Double(bytes: bytes)

        for _ in 0..<100 {
            let value = Double(bytes: bytes)
            #expect(value == firstValue, "Repeated deserialization should be deterministic")
        }
    }

    @Test func `same value from different sources produces same bytes`() {
        let pi1 = Double.pi
        let pi2 = 3.141592653589793

        let bytes1 = pi1.bytes()
        let bytes2 = pi2.bytes()

        #expect(bytes1 == bytes2, "Same double value should produce identical bytes")
    }
}
