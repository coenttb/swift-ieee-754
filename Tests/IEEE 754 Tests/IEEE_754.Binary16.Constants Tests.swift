// IEEE_754.Binary16.Constants Tests.swift
// swift-ieee-754
//
// Comprehensive tests for Binary16 (Float16) format constants

import Testing

@testable import IEEE_754

@Suite("IEEE_754.Binary16 Constants - Format Parameters")
struct Binary16FormatParametersTests {
    @Test func byteSize() {
        #expect(IEEE_754.Binary16.byteSize == 2, "Binary16 should be 2 bytes")
    }

    @Test func bitSize() {
        #expect(IEEE_754.Binary16.bitSize == 16, "Binary16 should be 16 bits")
    }

    @Test func signBits() {
        #expect(IEEE_754.Binary16.signBits == 1, "Binary16 has 1 sign bit")
    }

    @Test func exponentBits() {
        #expect(IEEE_754.Binary16.exponentBits == 5, "Binary16 has 5 exponent bits")
    }

    @Test func significandBits() {
        #expect(IEEE_754.Binary16.significandBits == 10, "Binary16 has 10 significand bits")
    }

    @Test func exponentBias() {
        #expect(IEEE_754.Binary16.exponentBias == 15, "Binary16 exponent bias is 15")
    }

    @Test func maxExponent() {
        #expect(IEEE_754.Binary16.maxExponent == 31, "Binary16 max exponent is 31")
    }

    @Test func precision() {
        #expect(IEEE_754.Binary16.precision == 11, "Binary16 precision (p) should be 11")
    }

    @Test func emin() {
        #expect(IEEE_754.Binary16.emin == -14, "Binary16 emin should be -14")
    }

    @Test func emax() {
        #expect(IEEE_754.Binary16.emax == 15, "Binary16 emax should be 15")
    }
}

@Suite("IEEE_754.Binary16 Constants - Consistency Tests")
struct Binary16ConsistencyTests {
    @Test func formatSizeConsistency() {
        let byteSize = IEEE_754.Binary16.byteSize
        let bitSize = IEEE_754.Binary16.bitSize
        #expect(byteSize * 8 == bitSize, "byteSize * 8 should equal bitSize")
    }

    @Test func bitFieldConsistency() {
        let signBits = IEEE_754.Binary16.signBits
        let exponentBits = IEEE_754.Binary16.exponentBits
        let significandBits = IEEE_754.Binary16.significandBits
        let totalBits = signBits + exponentBits + significandBits
        #expect(totalBits == IEEE_754.Binary16.bitSize, "Sum of bit fields should equal total bits")
    }

    @Test func precisionConsistency() {
        let precision = IEEE_754.Binary16.precision
        let significandBits = IEEE_754.Binary16.significandBits
        #expect(precision == significandBits + 1, "Precision should be significandBits + 1")
    }

    @Test func exponentRangeConsistency() {
        let emin = IEEE_754.Binary16.emin
        let emax = IEEE_754.Binary16.emax
        let bias = IEEE_754.Binary16.exponentBias

        #expect(emin == 1 - bias, "emin should equal 1 - bias")
        #expect(emax == bias, "emax should equal bias")
    }
}

#if canImport(FloatingPointTypes) && compiler(>=5.9)
@Suite("IEEE_754.Binary16 Constants - Value Tests", .enabled(if: {
    if #available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *) {
        return true
    }
    return false
}()))
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
struct Binary16ValueTests {
    @Test func epsilonValue() {
        let epsilon = IEEE_754.Binary16.epsilon
        #expect(epsilon == 0x1.0p-10, "Binary16 epsilon should be 2^-10")
    }

    @Test func minNormal() {
        let minNorm = IEEE_754.Binary16.minNormal
        #expect(minNorm == Float16.leastNormalMagnitude, "minNormal should equal Float16.leastNormalMagnitude")
        #expect(minNorm.isNormal, "minNormal should be a normal number")
    }

    @Test func minSubnormal() {
        let minSubnorm = IEEE_754.Binary16.minSubnormal
        #expect(minSubnorm == Float16.leastNonzeroMagnitude, "minSubnormal should equal Float16.leastNonzeroMagnitude")
        #expect(minSubnorm.isSubnormal, "minSubnormal should be subnormal")
    }

    @Test func maxNormal() {
        let maxNorm = IEEE_754.Binary16.maxNormal
        #expect(maxNorm == Float16.greatestFiniteMagnitude, "maxNormal should equal Float16.greatestFiniteMagnitude")
        #expect(maxNorm.isNormal, "maxNormal should be a normal number")
        #expect(maxNorm.isFinite, "maxNormal should be finite")
    }

    @Test func positiveZero() {
        let pz = IEEE_754.Binary16.SpecialValues.positiveZero
        #expect(pz == 0.0, "positiveZero should equal 0.0")
        #expect(pz.isZero, "positiveZero should be zero")
        #expect(pz.sign == .plus, "positiveZero should have positive sign")
    }

    @Test func negativeZero() {
        let nz = IEEE_754.Binary16.SpecialValues.negativeZero
        #expect(nz == 0.0, "negativeZero should equal 0.0")
        #expect(nz.isZero, "negativeZero should be zero")
        #expect(nz.sign == .minus, "negativeZero should have negative sign")
    }

    @Test func positiveInfinity() {
        let pinf = IEEE_754.Binary16.SpecialValues.positiveInfinity
        #expect(pinf == Float16.infinity, "positiveInfinity should equal Float16.infinity")
        #expect(pinf.isInfinite, "positiveInfinity should be infinite")
    }

    @Test func negativeInfinity() {
        let ninf = IEEE_754.Binary16.SpecialValues.negativeInfinity
        #expect(ninf == -Float16.infinity, "negativeInfinity should equal -Float16.infinity")
        #expect(ninf.isInfinite, "negativeInfinity should be infinite")
    }

    @Test func quietNaN() {
        let qnan = IEEE_754.Binary16.SpecialValues.quietNaN
        #expect(qnan.isNaN, "quietNaN should be NaN")
        #expect(!qnan.isSignalingNaN, "quietNaN should not be signaling")
    }

    @Test func signalingNaN() {
        let snan = IEEE_754.Binary16.SpecialValues.signalingNaN
        #expect(snan.isNaN, "signalingNaN should be NaN")
        #expect(snan.isSignalingNaN, "signalingNaN should be signaling")
    }
}
#endif
