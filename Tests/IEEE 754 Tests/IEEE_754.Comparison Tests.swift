// IEEE_754.Comparison Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 5.6 & 5.10 Comparison operations

import Testing

@testable import IEEE_754

// MARK: - Double Comparison Tests

@Suite("IEEE_754.Comparison - Double isEqual")
struct DoubleIsEqualTests {
    @Test(arguments: [(3.14, 3.14, true), (3.14, 2.71, false), (0.0, -0.0, true)])
    func equality(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isEqual(lhs, rhs) == expected)
    }

    @Test func nanEquality() {
        #expect(!IEEE_754.Comparison.isEqual(Double.nan, Double.nan), "NaN should not equal NaN")
        #expect(!IEEE_754.Comparison.isEqual(Double.nan, 3.14), "NaN should not equal number")
        #expect(!IEEE_754.Comparison.isEqual(3.14, Double.nan), "Number should not equal NaN")
    }

    @Test func signedZeros() {
        #expect(IEEE_754.Comparison.isEqual(0.0, -0.0), "Positive zero should equal negative zero")
        #expect(IEEE_754.Comparison.isEqual(-0.0, 0.0), "Negative zero should equal positive zero")
    }

    @Test func infinities() {
        #expect(IEEE_754.Comparison.isEqual(Double.infinity, Double.infinity), "Infinity should equal itself")
        #expect(IEEE_754.Comparison.isEqual(-Double.infinity, -Double.infinity), "Negative infinity should equal itself")
        #expect(!IEEE_754.Comparison.isEqual(Double.infinity, -Double.infinity), "Positive and negative infinity should not be equal")
    }
}

@Suite("IEEE_754.Comparison - Double isNotEqual")
struct DoubleIsNotEqualTests {
    @Test(arguments: [(3.14, 2.71, true), (3.14, 3.14, false)])
    func inequality(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isNotEqual(lhs, rhs) == expected)
    }

    @Test func nanInequality() {
        #expect(IEEE_754.Comparison.isNotEqual(Double.nan, Double.nan), "NaN should not equal NaN")
        #expect(IEEE_754.Comparison.isNotEqual(Double.nan, 3.14), "NaN should not equal number")
    }
}

@Suite("IEEE_754.Comparison - Double isLess")
struct DoubleIsLessTests {
    @Test(arguments: [
        (2.71, 3.14, true),
        (3.14, 2.71, false),
        (3.14, 3.14, false)
    ])
    func lessThan(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isLess(lhs, rhs) == expected)
    }

    @Test func nanComparisons() {
        #expect(!IEEE_754.Comparison.isLess(Double.nan, 3.14), "NaN comparisons should be false")
        #expect(!IEEE_754.Comparison.isLess(3.14, Double.nan), "NaN comparisons should be false")
        #expect(!IEEE_754.Comparison.isLess(Double.nan, Double.nan), "NaN comparisons should be false")
    }

    @Test func infinityComparisons() {
        #expect(IEEE_754.Comparison.isLess(-Double.infinity, 0.0), "-inf < 0")
        #expect(IEEE_754.Comparison.isLess(0.0, Double.infinity), "0 < +inf")
        #expect(!IEEE_754.Comparison.isLess(Double.infinity, Double.infinity), "+inf not < +inf")
    }
}

@Suite("IEEE_754.Comparison - Double isLessEqual")
struct DoubleIsLessEqualTests {
    @Test(arguments: [
        (2.71, 3.14, true),
        (3.14, 3.14, true),
        (3.14, 2.71, false)
    ])
    func lessEqual(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isLessEqual(lhs, rhs) == expected)
    }

    @Test func signedZeros() {
        #expect(IEEE_754.Comparison.isLessEqual(0.0, -0.0), "0.0 <= -0.0")
        #expect(IEEE_754.Comparison.isLessEqual(-0.0, 0.0), "-0.0 <= 0.0")
    }
}

@Suite("IEEE_754.Comparison - Double isGreater")
struct DoubleIsGreaterTests {
    @Test(arguments: [
        (3.14, 2.71, true),
        (2.71, 3.14, false),
        (3.14, 3.14, false)
    ])
    func greaterThan(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isGreater(lhs, rhs) == expected)
    }

    @Test func nanComparisons() {
        #expect(!IEEE_754.Comparison.isGreater(Double.nan, 3.14), "NaN comparisons should be false")
        #expect(!IEEE_754.Comparison.isGreater(3.14, Double.nan), "NaN comparisons should be false")
    }
}

@Suite("IEEE_754.Comparison - Double isGreaterEqual")
struct DoubleIsGreaterEqualTests {
    @Test(arguments: [
        (3.14, 2.71, true),
        (3.14, 3.14, true),
        (2.71, 3.14, false)
    ])
    func greaterEqual(lhs: Double, rhs: Double, expected: Bool) {
        #expect(IEEE_754.Comparison.isGreaterEqual(lhs, rhs) == expected)
    }
}

@Suite("IEEE_754.Comparison - Double totalOrder")
struct DoubleTotalOrderTests {
    @Test func signedZeroOrdering() {
        #expect(IEEE_754.Comparison.totalOrder(-0.0, 0.0), "-0 should be ordered before +0")
        #expect(!IEEE_754.Comparison.totalOrder(0.0, -0.0), "+0 should not be ordered before -0")
    }

    @Test func nanOrdering() {
        // NaN values are ordered after all non-NaN values
        #expect(!IEEE_754.Comparison.totalOrder(Double.nan, 3.14), "NaN should not be ordered before numbers")
        #expect(IEEE_754.Comparison.totalOrder(3.14, Double.nan), "Numbers should be ordered before NaN")
        #expect(!IEEE_754.Comparison.totalOrder(Double.nan, Double.infinity), "NaN should not be ordered before infinity")
    }

    @Test func infinityOrdering() {
        #expect(IEEE_754.Comparison.totalOrder(-Double.infinity, 0.0), "-inf before 0")
        #expect(IEEE_754.Comparison.totalOrder(0.0, Double.infinity), "0 before +inf")
        #expect(IEEE_754.Comparison.totalOrder(-Double.infinity, Double.infinity), "-inf before +inf")
    }

    @Test func normalValueOrdering() {
        #expect(IEEE_754.Comparison.totalOrder(-100.0, -10.0), "-100 before -10")
        #expect(IEEE_754.Comparison.totalOrder(-10.0, -1.0), "-10 before -1")
        #expect(IEEE_754.Comparison.totalOrder(-1.0, 0.0), "-1 before 0")
        #expect(IEEE_754.Comparison.totalOrder(0.0, 1.0), "0 before 1")
        #expect(IEEE_754.Comparison.totalOrder(1.0, 10.0), "1 before 10")
    }

    @Test func completeOrdering() {
        // totalOrder defines a complete ordering: -NaN < -Inf < -Finite < -0 < +0 < +Finite < +Inf < +NaN
        let values: [Double] = [-Double.infinity, -100.0, -1.0, -0.0, 0.0, 1.0, 100.0, Double.infinity]
        for i in 0..<values.count - 1 {
            #expect(IEEE_754.Comparison.totalOrder(values[i], values[i + 1]),
                    "\(values[i]) should be ordered before \(values[i + 1])")
        }
    }
}

@Suite("IEEE_754.Comparison - Double totalOrderMag")
struct DoubleTotalOrderMagTests {
    @Test func magnitudeOrdering() {
        #expect(IEEE_754.Comparison.totalOrderMag(2.71, 3.14), "|2.71| < |3.14|")
        #expect(IEEE_754.Comparison.totalOrderMag(-2.71, 3.14), "|-2.71| < |3.14|")
        #expect(IEEE_754.Comparison.totalOrderMag(-3.14, 2.71) == false, "|-3.14| not < |2.71|")
    }

    @Test func zeroMagnitude() {
        #expect(IEEE_754.Comparison.totalOrderMag(0.0, 1.0), "|0| < |1|")
        #expect(IEEE_754.Comparison.totalOrderMag(-0.0, 1.0), "|-0| < |1|")
    }

    @Test func infinityMagnitude() {
        #expect(IEEE_754.Comparison.totalOrderMag(1.0, Double.infinity), "|1| < |inf|")
        #expect(IEEE_754.Comparison.totalOrderMag(1.0, -Double.infinity), "|1| < |-inf|")
    }
}

// MARK: - Float Comparison Tests

@Suite("IEEE_754.Comparison - Float isEqual")
struct FloatIsEqualTests {
    @Test(arguments: [
        (Float(3.14), Float(3.14), true),
        (Float(3.14), Float(2.71), false),
        (Float(0.0), Float(-0.0), true)
    ])
    func equality(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isEqual(lhs, rhs) == expected)
    }

    @Test func nanEquality() {
        #expect(!IEEE_754.Comparison.isEqual(Float.nan, Float.nan), "NaN should not equal NaN")
        #expect(!IEEE_754.Comparison.isEqual(Float.nan, Float(3.14)), "NaN should not equal number")
    }
}

@Suite("IEEE_754.Comparison - Float isNotEqual")
struct FloatIsNotEqualTests {
    @Test(arguments: [
        (Float(3.14), Float(2.71), true),
        (Float(3.14), Float(3.14), false)
    ])
    func inequality(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isNotEqual(lhs, rhs) == expected)
    }
}

@Suite("IEEE_754.Comparison - Float isLess")
struct FloatIsLessTests {
    @Test(arguments: [
        (Float(2.71), Float(3.14), true),
        (Float(3.14), Float(2.71), false),
        (Float(3.14), Float(3.14), false)
    ])
    func lessThan(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isLess(lhs, rhs) == expected)
    }

    @Test func nanComparisons() {
        #expect(!IEEE_754.Comparison.isLess(Float.nan, Float(3.14)), "NaN comparisons should be false")
        #expect(!IEEE_754.Comparison.isLess(Float(3.14), Float.nan), "NaN comparisons should be false")
    }
}

@Suite("IEEE_754.Comparison - Float isLessEqual")
struct FloatIsLessEqualTests {
    @Test(arguments: [
        (Float(2.71), Float(3.14), true),
        (Float(3.14), Float(3.14), true),
        (Float(3.14), Float(2.71), false)
    ])
    func lessEqual(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isLessEqual(lhs, rhs) == expected)
    }
}

@Suite("IEEE_754.Comparison - Float isGreater")
struct FloatIsGreaterTests {
    @Test(arguments: [
        (Float(3.14), Float(2.71), true),
        (Float(2.71), Float(3.14), false),
        (Float(3.14), Float(3.14), false)
    ])
    func greaterThan(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isGreater(lhs, rhs) == expected)
    }
}

@Suite("IEEE_754.Comparison - Float isGreaterEqual")
struct FloatIsGreaterEqualTests {
    @Test(arguments: [
        (Float(3.14), Float(2.71), true),
        (Float(3.14), Float(3.14), true),
        (Float(2.71), Float(3.14), false)
    ])
    func greaterEqual(lhs: Float, rhs: Float, expected: Bool) {
        #expect(IEEE_754.Comparison.isGreaterEqual(lhs, rhs) == expected)
    }
}

@Suite("IEEE_754.Comparison - Float totalOrder")
struct FloatTotalOrderTests {
    @Test func signedZeroOrdering() {
        #expect(IEEE_754.Comparison.totalOrder(Float(-0.0), Float(0.0)), "-0 should be ordered before +0")
        #expect(!IEEE_754.Comparison.totalOrder(Float(0.0), Float(-0.0)), "+0 should not be ordered before -0")
    }

    @Test func nanOrdering() {
        #expect(!IEEE_754.Comparison.totalOrder(Float.nan, Float(3.14)), "NaN should not be ordered before numbers")
        #expect(IEEE_754.Comparison.totalOrder(Float(3.14), Float.nan), "Numbers should be ordered before NaN")
    }

    @Test func completeOrdering() {
        let values: [Float] = [-Float.infinity, Float(-100.0), Float(-1.0), Float(-0.0), Float(0.0), Float(1.0), Float(100.0), Float.infinity]
        for i in 0..<values.count - 1 {
            #expect(IEEE_754.Comparison.totalOrder(values[i], values[i + 1]),
                    "\(values[i]) should be ordered before \(values[i + 1])")
        }
    }
}

@Suite("IEEE_754.Comparison - Float totalOrderMag")
struct FloatTotalOrderMagTests {
    @Test func magnitudeOrdering() {
        #expect(IEEE_754.Comparison.totalOrderMag(Float(2.71), Float(3.14)), "|2.71| < |3.14|")
        #expect(IEEE_754.Comparison.totalOrderMag(Float(-2.71), Float(3.14)), "|-2.71| < |3.14|")
        #expect(!IEEE_754.Comparison.totalOrderMag(Float(-3.14), Float(2.71)), "|-3.14| not < |2.71|")
    }
}

// MARK: - Hierarchical Predicate API Tests

@Suite("IEEE_754.Comparison - Hierarchical Predicate API")
struct ComparisonPredicateTests {
    @Test("compare with Predicate enum - equality(.equal)")
    func compareEqual() {
        #expect(IEEE_754.Comparison.compare(3.14, 3.14, using: .equality(.equal)))
        #expect(!IEEE_754.Comparison.compare(3.14, 2.71, using: .equality(.equal)))
        #expect(IEEE_754.Comparison.compare(Float(3.14), Float(3.14), using: .equality(.equal)))
    }

    @Test("compare with Predicate enum - equality(.notEqual)")
    func compareNotEqual() {
        #expect(IEEE_754.Comparison.compare(3.14, 2.71, using: .equality(.notEqual)))
        #expect(!IEEE_754.Comparison.compare(3.14, 3.14, using: .equality(.notEqual)))
        #expect(IEEE_754.Comparison.compare(Float(3.14), Float(2.71), using: .equality(.notEqual)))
    }

    @Test("compare with Predicate enum - ordering(.less(orEqual: false))")
    func compareLess() {
        #expect(IEEE_754.Comparison.compare(2.71, 3.14, using: .ordering(.less(orEqual: false))))
        #expect(!IEEE_754.Comparison.compare(3.14, 2.71, using: .ordering(.less(orEqual: false))))
        #expect(!IEEE_754.Comparison.compare(3.14, 3.14, using: .ordering(.less(orEqual: false))))
    }

    @Test("compare with Predicate enum - ordering(.less(orEqual: true))")
    func compareLessEqual() {
        #expect(IEEE_754.Comparison.compare(2.71, 3.14, using: .ordering(.less(orEqual: true))))
        #expect(IEEE_754.Comparison.compare(3.14, 3.14, using: .ordering(.less(orEqual: true))))
        #expect(!IEEE_754.Comparison.compare(3.14, 2.71, using: .ordering(.less(orEqual: true))))
    }

    @Test("compare with Predicate enum - ordering(.greater(orEqual: false))")
    func compareGreater() {
        #expect(IEEE_754.Comparison.compare(3.14, 2.71, using: .ordering(.greater(orEqual: false))))
        #expect(!IEEE_754.Comparison.compare(2.71, 3.14, using: .ordering(.greater(orEqual: false))))
        #expect(!IEEE_754.Comparison.compare(3.14, 3.14, using: .ordering(.greater(orEqual: false))))
    }

    @Test("compare with Predicate enum - ordering(.greater(orEqual: true))")
    func compareGreaterEqual() {
        #expect(IEEE_754.Comparison.compare(3.14, 2.71, using: .ordering(.greater(orEqual: true))))
        #expect(IEEE_754.Comparison.compare(3.14, 3.14, using: .ordering(.greater(orEqual: true))))
        #expect(!IEEE_754.Comparison.compare(2.71, 3.14, using: .ordering(.greater(orEqual: true))))
    }

    @Test("Predicate enum pattern matching works correctly")
    func predicatePatternMatching() {
        let predicates: [IEEE_754.Comparison.Predicate] = [
            .equality(.equal),
            .equality(.notEqual),
            .ordering(.less(orEqual: false)),
            .ordering(.less(orEqual: true)),
            .ordering(.greater(orEqual: false)),
            .ordering(.greater(orEqual: true))
        ]

        for predicate in predicates {
            let result = IEEE_754.Comparison.compare(3.0, 3.0, using: predicate)

            switch predicate {
            case .equality(.equal):
                #expect(result == true)
            case .equality(.notEqual):
                #expect(result == false)
            case .ordering(.less(orEqual: let orEqual)):
                #expect(result == orEqual)
            case .ordering(.greater(orEqual: let orEqual)):
                #expect(result == orEqual)
            }
        }
    }
}
