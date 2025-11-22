// IEEE_754.Exceptions Tests.swift
// swift-ieee-754
//
// Comprehensive tests for IEEE 754-2019 Section 7 Exception Handling

import Testing

@testable import IEEE_754

// MARK: - Exception Flag Tests

@Suite("IEEE_754.Exceptions - Flag Operations", .serialized)
struct ExceptionFlagTests {
    @Test func raiseAndTestInvalid() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
    }

    @Test func raiseAndTestDivisionByZero() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.divisionByZero)
        #expect(IEEE_754.Exceptions.testFlag(.divisionByZero))
        #expect(!IEEE_754.Exceptions.testFlag(.invalid))
    }

    @Test func raiseAndTestOverflow() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.testFlag(.overflow))
        #expect(!IEEE_754.Exceptions.testFlag(.underflow))
    }

    @Test func raiseAndTestUnderflow() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.underflow)
        #expect(IEEE_754.Exceptions.testFlag(.underflow))
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
    }

    @Test func raiseAndTestInexact() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.testFlag(.inexact))
        #expect(!IEEE_754.Exceptions.testFlag(.invalid))
    }

    @Test func clearSpecificFlag() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(IEEE_754.Exceptions.testFlag(.overflow))

        IEEE_754.Exceptions.clear(.invalid)
        #expect(!IEEE_754.Exceptions.testFlag(.invalid))
        #expect(IEEE_754.Exceptions.testFlag(.overflow))
    }

    @Test func clearAllFlags() {
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.divisionByZero)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.underflow)
        IEEE_754.Exceptions.raise(.inexact)

        IEEE_754.Exceptions.clearAll()

        #expect(!IEEE_754.Exceptions.testFlag(.invalid))
        #expect(!IEEE_754.Exceptions.testFlag(.divisionByZero))
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
        #expect(!IEEE_754.Exceptions.testFlag(.underflow))
        #expect(!IEEE_754.Exceptions.testFlag(.inexact))
    }

    @Test func multipleFlags() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)

        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(IEEE_754.Exceptions.testFlag(.overflow))
        #expect(IEEE_754.Exceptions.testFlag(.inexact))
        #expect(!IEEE_754.Exceptions.testFlag(.underflow))
        #expect(!IEEE_754.Exceptions.testFlag(.divisionByZero))
    }

    @Test func anyRaisedWhenNoFlags() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.anyRaised())
    }

    @Test func anyRaisedWhenOneFlagSet() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.anyRaised())
    }

    @Test func anyRaisedWhenMultipleFlags() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.anyRaised())
    }

    @Test func getRaisedFlagsWhenNone() {
        IEEE_754.Exceptions.clearAll()
        let raised = IEEE_754.Exceptions.getRaisedFlags()
        #expect(raised.isEmpty)
    }

    @Test func getRaisedFlagsWhenOne() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.overflow)
        let raised = IEEE_754.Exceptions.getRaisedFlags()
        #expect(raised.count == 1)
        #expect(raised.contains(.overflow))
    }

    @Test func getRaisedFlagsWhenMultiple() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)
        let raised = IEEE_754.Exceptions.getRaisedFlags()
        #expect(raised.count == 3)
        #expect(raised.contains(.invalid))
        #expect(raised.contains(.overflow))
        #expect(raised.contains(.inexact))
    }

    @Test func getRaisedFlagsWhenAll() {
        IEEE_754.Exceptions.clearAll()
        for flag in IEEE_754.Exceptions.Flag.allCases {
            IEEE_754.Exceptions.raise(flag)
        }
        let raised = IEEE_754.Exceptions.getRaisedFlags()
        #expect(raised.count == 5)
    }
}

// MARK: - Compatibility API Tests

@Suite("IEEE_754.Exceptions - Compatibility Properties", .serialized)
struct ExceptionCompatibilityTests {
    @Test func invalidOperationProperty() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.invalidOperation)
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.invalidOperation)
    }

    @Test func divisionByZeroProperty() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.divisionByZero)
        IEEE_754.Exceptions.raise(.divisionByZero)
        #expect(IEEE_754.Exceptions.divisionByZero)
    }

    @Test func overflowProperty() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.overflow)
        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.overflow)
    }

    @Test func underflowProperty() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.underflow)
        IEEE_754.Exceptions.raise(.underflow)
        #expect(IEEE_754.Exceptions.underflow)
    }

    @Test func inexactProperty() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.inexact)
        IEEE_754.Exceptions.raise(.inexact)
        #expect(IEEE_754.Exceptions.inexact)
    }
}

// MARK: - Flag Enum Tests

@Suite("IEEE_754.Exceptions - Flag Enum")
struct ExceptionFlagEnumTests {
    @Test func flagDescription() {
        #expect(IEEE_754.Exceptions.Flag.invalid.description == "invalid")
        #expect(IEEE_754.Exceptions.Flag.divisionByZero.description == "divisionByZero")
        #expect(IEEE_754.Exceptions.Flag.overflow.description == "overflow")
        #expect(IEEE_754.Exceptions.Flag.underflow.description == "underflow")
        #expect(IEEE_754.Exceptions.Flag.inexact.description == "inexact")
    }

    @Test func flagEquality() {
        #expect(IEEE_754.Exceptions.Flag.invalid == .invalid)
        #expect(IEEE_754.Exceptions.Flag.invalid != .overflow)
    }

    @Test func allCasesCount() {
        #expect(IEEE_754.Exceptions.Flag.allCases.count == 5)
    }

    @Test func allCasesContainsAll() {
        let allCases = IEEE_754.Exceptions.Flag.allCases
        #expect(allCases.contains(.invalid))
        #expect(allCases.contains(.divisionByZero))
        #expect(allCases.contains(.overflow))
        #expect(allCases.contains(.underflow))
        #expect(allCases.contains(.inexact))
    }
}

// MARK: - Idempotency Tests

@Suite("IEEE_754.Exceptions - Idempotency", .serialized)
struct ExceptionIdempotencyTests {
    @Test func raisingTwiceHasNoEffect() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))

        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
    }

    @Test func clearingTwiceHasNoEffect() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.clear(.overflow)
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))

        IEEE_754.Exceptions.clear(.overflow)
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
    }

    @Test func clearAllOnEmptyStateHasNoEffect() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.anyRaised())
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.anyRaised())
    }
}

// MARK: - Independence Tests

@Suite("IEEE_754.Exceptions - Flag Independence", .serialized)
struct ExceptionIndependenceTests {
    @Test func flagsAreIndependent() {
        IEEE_754.Exceptions.clearAll()

        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(!IEEE_754.Exceptions.testFlag(.divisionByZero))
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
        #expect(!IEEE_754.Exceptions.testFlag(.underflow))
        #expect(!IEEE_754.Exceptions.testFlag(.inexact))

        IEEE_754.Exceptions.raise(.overflow)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(!IEEE_754.Exceptions.testFlag(.divisionByZero))
        #expect(IEEE_754.Exceptions.testFlag(.overflow))
        #expect(!IEEE_754.Exceptions.testFlag(.underflow))
        #expect(!IEEE_754.Exceptions.testFlag(.inexact))
    }

    @Test func clearingOneFlagDoesNotAffectOthers() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        IEEE_754.Exceptions.raise(.overflow)
        IEEE_754.Exceptions.raise(.inexact)

        IEEE_754.Exceptions.clear(.overflow)

        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        #expect(!IEEE_754.Exceptions.testFlag(.overflow))
        #expect(IEEE_754.Exceptions.testFlag(.inexact))
    }
}

// MARK: - Thread Safety Tests

@Suite("IEEE_754.Exceptions - Thread Independence", .serialized)
struct ExceptionThreadTests {
    @Test func initialStateIsClean() {
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.anyRaised())
    }

    @Test func stateCanBeSetAndQueried() {
        IEEE_754.Exceptions.clearAll()
        IEEE_754.Exceptions.raise(.invalid)
        #expect(IEEE_754.Exceptions.testFlag(.invalid))
        IEEE_754.Exceptions.clearAll()
        #expect(!IEEE_754.Exceptions.testFlag(.invalid))
    }
}
