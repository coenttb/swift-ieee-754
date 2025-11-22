// IEEE_754.NextOperations Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.3.1 Next operations

import Testing

@testable import IEEE_754

// MARK: - Double NextOperations Tests

@Suite("IEEE_754.NextOperations - Double nextUp")
struct DoubleNextUpTests {
    @Test func normalValues() {
        let value = 1.0
        let next = IEEE_754.NextOperations.nextUp(value)
        #expect(next > value, "nextUp should be greater than original")
        #expect(next == value.nextUp, "Should match Swift's nextUp")
    }

    @Test func fromZero() {
        let next = IEEE_754.NextOperations.nextUp(0.0)
        #expect(next == Double.leastNonzeroMagnitude, "nextUp(0) should be leastNonzeroMagnitude")
        #expect(next > 0.0, "nextUp(0) should be positive")
    }

    @Test func fromNegativeZero() {
        let next = IEEE_754.NextOperations.nextUp(-0.0)
        #expect(next == Double.leastNonzeroMagnitude, "nextUp(-0) should be leastNonzeroMagnitude")
        #expect(next > 0.0, "nextUp(-0) should be positive")
    }

    @Test func fromInfinity() {
        let next = IEEE_754.NextOperations.nextUp(Double.infinity)
        #expect(next.isInfinite, "nextUp(+inf) should be +inf")
        #expect(next.sign == .plus, "nextUp(+inf) should be positive")
    }

    @Test func fromNaN() {
        let next = IEEE_754.NextOperations.nextUp(Double.nan)
        #expect(next.isNaN, "nextUp(NaN) should be NaN")
    }

    @Test func fromMaxFinite() {
        let maxFinite = Double.greatestFiniteMagnitude
        let next = IEEE_754.NextOperations.nextUp(maxFinite)
        #expect(next.isInfinite, "nextUp(maxFinite) should overflow to infinity")
        #expect(next.sign == .plus, "Should be positive infinity")
    }

    @Test func acrossSubnormalBoundary() {
        let maxSubnorm = Double.leastNormalMagnitude.nextDown
        #expect(maxSubnorm.isSubnormal, "Setup: should be subnormal")
        let next = IEEE_754.NextOperations.nextUp(maxSubnorm)
        #expect(next.isNormal, "nextUp from maxSubnormal should be normal")
        #expect(next == Double.leastNormalMagnitude, "Should be leastNormalMagnitude")
    }
}

@Suite("IEEE_754.NextOperations - Double nextDown")
struct DoubleNextDownTests {
    @Test func normalValues() {
        let value = 1.0
        let next = IEEE_754.NextOperations.nextDown(value)
        #expect(next < value, "nextDown should be less than original")
        #expect(next == value.nextDown, "Should match Swift's nextDown")
    }

    @Test func fromZero() {
        let next = IEEE_754.NextOperations.nextDown(0.0)
        #expect(next == -Double.leastNonzeroMagnitude, "nextDown(0) should be -leastNonzeroMagnitude")
        #expect(next < 0.0, "nextDown(0) should be negative")
    }

    @Test func fromNegativeZero() {
        let next = IEEE_754.NextOperations.nextDown(-0.0)
        #expect(next == -Double.leastNonzeroMagnitude, "nextDown(-0) should be -leastNonzeroMagnitude")
        #expect(next < 0.0, "nextDown(-0) should be negative")
    }

    @Test func fromNegativeInfinity() {
        let next = IEEE_754.NextOperations.nextDown(-Double.infinity)
        #expect(next.isInfinite, "nextDown(-inf) should be -inf")
        #expect(next.sign == .minus, "nextDown(-inf) should be negative")
    }

    @Test func fromNaN() {
        let next = IEEE_754.NextOperations.nextDown(Double.nan)
        #expect(next.isNaN, "nextDown(NaN) should be NaN")
    }

    @Test func fromMinFinite() {
        let minFinite = -Double.greatestFiniteMagnitude
        let next = IEEE_754.NextOperations.nextDown(minFinite)
        #expect(next.isInfinite, "nextDown(minFinite) should overflow to -infinity")
        #expect(next.sign == .minus, "Should be negative infinity")
    }

    @Test func acrossSubnormalBoundary() {
        let minNorm = Double.leastNormalMagnitude
        #expect(minNorm.isNormal, "Setup: should be normal")
        let next = IEEE_754.NextOperations.nextDown(minNorm)
        #expect(next.isSubnormal, "nextDown from leastNormalMagnitude should be subnormal")
    }
}

@Suite("IEEE_754.NextOperations - Double nextAfter")
struct DoubleNextAfterTests {
    @Test func towardLarger() {
        let result = IEEE_754.NextOperations.nextAfter(1.0, toward: 2.0)
        #expect(result > 1.0, "nextAfter toward larger should increase")
        #expect(result == 1.0.nextUp, "Should equal nextUp")
    }

    @Test func towardSmaller() {
        let result = IEEE_754.NextOperations.nextAfter(1.0, toward: 0.0)
        #expect(result < 1.0, "nextAfter toward smaller should decrease")
        #expect(result == 1.0.nextDown, "Should equal nextDown")
    }

    @Test func towardSelf() {
        let result = IEEE_754.NextOperations.nextAfter(1.0, toward: 1.0)
        #expect(result == 1.0, "nextAfter toward self should return unchanged")
    }

    @Test func nanHandling() {
        let result1 = IEEE_754.NextOperations.nextAfter(Double.nan, toward: 1.0)
        #expect(result1.isNaN, "nextAfter(NaN, x) should be NaN")

        let result2 = IEEE_754.NextOperations.nextAfter(1.0, toward: Double.nan)
        #expect(result2.isNaN, "nextAfter(x, NaN) should be NaN")
    }

    @Test func zeroTransition() {
        let result1 = IEEE_754.NextOperations.nextAfter(-0.0, toward: 0.0)
        #expect(result1 == 0.0 && result1.sign == .plus, "nextAfter(-0, +0) should be +0")

        let result2 = IEEE_754.NextOperations.nextAfter(0.0, toward: -0.0)
        #expect(result2 == -0.0 && result2.sign == .minus, "nextAfter(+0, -0) should be -0")
    }

    @Test func towardInfinity() {
        let maxFinite = Double.greatestFiniteMagnitude
        let result = IEEE_754.NextOperations.nextAfter(maxFinite, toward: Double.infinity)
        #expect(result.isInfinite, "nextAfter(maxFinite, +inf) should be +inf")
    }

    @Test func crossingZero() {
        let tiny = Double.leastNonzeroMagnitude
        let result = IEEE_754.NextOperations.nextAfter(tiny, toward: -1.0)
        #expect(result == 0.0, "nextAfter(leastNonzero, negative) should be 0")
    }
}

// MARK: - Float NextOperations Tests

@Suite("IEEE_754.NextOperations - Float nextUp")
struct FloatNextUpTests {
    @Test func normalValues() {
        let value = Float(1.0)
        let next = IEEE_754.NextOperations.nextUp(value)
        #expect(next > value, "nextUp should be greater than original")
        #expect(next == value.nextUp, "Should match Swift's nextUp")
    }

    @Test func fromZero() {
        let next = IEEE_754.NextOperations.nextUp(Float(0.0))
        #expect(next == Float.leastNonzeroMagnitude, "nextUp(0) should be leastNonzeroMagnitude")
    }

    @Test func fromInfinity() {
        let next = IEEE_754.NextOperations.nextUp(Float.infinity)
        #expect(next.isInfinite, "nextUp(+inf) should be +inf")
    }

    @Test func fromNaN() {
        let next = IEEE_754.NextOperations.nextUp(Float.nan)
        #expect(next.isNaN, "nextUp(NaN) should be NaN")
    }
}

@Suite("IEEE_754.NextOperations - Float nextDown")
struct FloatNextDownTests {
    @Test func normalValues() {
        let value = Float(1.0)
        let next = IEEE_754.NextOperations.nextDown(value)
        #expect(next < value, "nextDown should be less than original")
        #expect(next == value.nextDown, "Should match Swift's nextDown")
    }

    @Test func fromZero() {
        let next = IEEE_754.NextOperations.nextDown(Float(0.0))
        #expect(next == -Float.leastNonzeroMagnitude, "nextDown(0) should be -leastNonzeroMagnitude")
    }

    @Test func fromNegativeInfinity() {
        let next = IEEE_754.NextOperations.nextDown(-Float.infinity)
        #expect(next.isInfinite, "nextDown(-inf) should be -inf")
    }
}

@Suite("IEEE_754.NextOperations - Float nextAfter")
struct FloatNextAfterTests {
    @Test func towardLarger() {
        let result = IEEE_754.NextOperations.nextAfter(Float(1.0), toward: Float(2.0))
        #expect(result > Float(1.0), "nextAfter toward larger should increase")
        #expect(result == Float(1.0).nextUp, "Should equal nextUp")
    }

    @Test func towardSmaller() {
        let result = IEEE_754.NextOperations.nextAfter(Float(1.0), toward: Float(0.0))
        #expect(result < Float(1.0), "nextAfter toward smaller should decrease")
    }

    @Test func towardSelf() {
        let result = IEEE_754.NextOperations.nextAfter(Float(1.0), toward: Float(1.0))
        #expect(result == Float(1.0), "nextAfter toward self should return unchanged")
    }

    @Test func nanHandling() {
        let result = IEEE_754.NextOperations.nextAfter(Float.nan, toward: Float(1.0))
        #expect(result.isNaN, "nextAfter(NaN, x) should be NaN")
    }
}

// MARK: - Edge Cases

@Suite("IEEE_754.NextOperations - Edge Cases")
struct NextOperationsEdgeCasesTests {
    @Test func ulpConsistency() {
        let value = 1.0
        let nextUp = IEEE_754.NextOperations.nextUp(value)
        let difference = nextUp - value
        #expect(difference == value.ulp, "Difference should equal ULP at 1.0")
    }

    @Test func symmetry() {
        let value = 3.14
        let up = IEEE_754.NextOperations.nextUp(value)
        let down = IEEE_754.NextOperations.nextDown(up)
        #expect(down == value, "nextDown(nextUp(x)) should equal x")
    }

    @Test func negativeSymmetry() {
        let value = -3.14
        let down = IEEE_754.NextOperations.nextDown(value)
        let up = IEEE_754.NextOperations.nextUp(down)
        #expect(up == value, "nextUp(nextDown(x)) should equal x")
    }
}
