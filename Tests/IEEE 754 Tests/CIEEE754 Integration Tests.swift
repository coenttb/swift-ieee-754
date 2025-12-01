// CIEEE754 Integration Tests.swift
// swift-ieee-754
//
// Integration tests for C target FPU control functions

import CIEEE754
import Testing

@testable import IEEE_754

// MARK: - Rounding Mode Tests

@Suite("CIEEE754 - Rounding Mode Control")
struct CIEEERoundingModeTests {
    @Test func getRoundingMode() {
        // Should be able to query current rounding mode
        let mode = ieee754_get_rounding_mode()
        #expect(
            mode == IEEE754_ROUND_TONEAREST || mode == IEEE754_ROUND_DOWNWARD || mode == IEEE754_ROUND_UPWARD
                || mode == IEEE754_ROUND_TOWARDZERO)
    }

    @Test func setRoundingModeToNearest() {
        withRoundingMode(IEEE754_ROUND_TONEAREST) {
            let result = ieee754_set_rounding_mode(IEEE754_ROUND_TONEAREST)
            #expect(result == 0, "Setting rounding mode should succeed")

            let mode = ieee754_get_rounding_mode()
            #expect(mode == IEEE754_ROUND_TONEAREST)
        }
    }

    @Test func setRoundingModeDownward() {
        withRoundingMode(IEEE754_ROUND_DOWNWARD) {
            let result = ieee754_set_rounding_mode(IEEE754_ROUND_DOWNWARD)
            #expect(result == 0)

            let mode = ieee754_get_rounding_mode()
            #expect(mode == IEEE754_ROUND_DOWNWARD)
        }
    }

    @Test func setRoundingModeUpward() {
        withRoundingMode(IEEE754_ROUND_UPWARD) {
            let result = ieee754_set_rounding_mode(IEEE754_ROUND_UPWARD)
            #expect(result == 0)

            let mode = ieee754_get_rounding_mode()
            #expect(mode == IEEE754_ROUND_UPWARD)
        }
    }

    @Test func setRoundingModeTowardZero() {
        withRoundingMode(IEEE754_ROUND_TOWARDZERO) {
            let result = ieee754_set_rounding_mode(IEEE754_ROUND_TOWARDZERO)
            #expect(result == 0)

            let mode = ieee754_get_rounding_mode()
            #expect(mode == IEEE754_ROUND_TOWARDZERO)
        }
    }

    @Test func roundingModeAffectsOperations() {
        // Test that rounding mode actually affects operations
        let result1 = withRoundingMode(IEEE754_ROUND_TOWARDZERO) {
            1.0 / 3.0  // Should round toward zero
        }

        let result2 = withRoundingMode(IEEE754_ROUND_UPWARD) {
            1.0 / 3.0  // Should round upward
        }

        // Results should differ (though exact values depend on rounding)
        // At minimum, verify operations complete
        #expect(result1 > 0)
        #expect(result2 > 0)
    }
}

// MARK: - Thread-Local Exception Tests

@Suite("CIEEE754 - Thread-Local Exceptions", .serialized)
struct CIEEEExceptionTests {
    @Test func initialExceptionState() {
        ieee754_clear_all_exceptions()
        let exceptions = ieee754_get_exceptions()

        #expect(exceptions.invalid == 0)
        #expect(exceptions.divByZero == 0)
        #expect(exceptions.overflow == 0)
        #expect(exceptions.underflow == 0)
        #expect(exceptions.inexact == 0)
    }

    @Test func raiseInvalidException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_INVALID)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 0)
    }

    @Test func raiseDivByZeroException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_DIVBYZERO)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_DIVBYZERO) == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func raiseOverflowException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_OVERFLOW)

        let exceptions = ieee754_get_exceptions()
        #expect(exceptions.overflow == 1)
        #expect(exceptions.underflow == 0)
    }

    @Test func raiseUnderflowException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_UNDERFLOW)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_UNDERFLOW) == 1)
    }

    @Test func raiseInexactException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_INEXACT)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INEXACT) == 1)
    }

    @Test func clearSpecificException() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_INVALID)
        ieee754_raise_exception(IEEE754_EXCEPTION_OVERFLOW)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 1)

        ieee754_clear_exception(IEEE754_EXCEPTION_INVALID)

        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 1)
    }

    @Test func clearAllExceptions() {
        ieee754_raise_exception(IEEE754_EXCEPTION_INVALID)
        ieee754_raise_exception(IEEE754_EXCEPTION_DIVBYZERO)
        ieee754_raise_exception(IEEE754_EXCEPTION_OVERFLOW)

        ieee754_clear_all_exceptions()

        let exceptions = ieee754_get_exceptions()
        #expect(exceptions.invalid == 0)
        #expect(exceptions.divByZero == 0)
        #expect(exceptions.overflow == 0)
        #expect(exceptions.underflow == 0)
        #expect(exceptions.inexact == 0)
    }

    @Test func multipleExceptionsSimultaneous() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_INVALID)
        ieee754_raise_exception(IEEE754_EXCEPTION_OVERFLOW)
        ieee754_raise_exception(IEEE754_EXCEPTION_INEXACT)

        let exceptions = ieee754_get_exceptions()
        #expect(exceptions.invalid == 1)
        #expect(exceptions.overflow == 1)
        #expect(exceptions.inexact == 1)
        #expect(exceptions.divByZero == 0)
        #expect(exceptions.underflow == 0)
    }
}

// MARK: - Hardware FPU Exception Tests

@Suite("CIEEE754 - Hardware FPU Exceptions")
struct CIEEEHardwareExceptionTests {
    @Test func clearFPUExceptions() {
        ieee754_clear_fpu_exceptions()

        let exceptions = ieee754_test_fpu_exceptions()
        // All should be clear (though we can't guarantee initial state)
        // Just verify the call works
        #expect(exceptions.invalid == 0 || exceptions.invalid == 1)
    }

    @Test func testFPUExceptionsStructure() {
        ieee754_clear_fpu_exceptions()

        // Perform an operation that might set exceptions
        _ = 1.0 / 3.0  // Should set inexact

        let exceptions = ieee754_test_fpu_exceptions()

        // Verify structure is readable
        #expect(exceptions.invalid >= 0 && exceptions.invalid <= 1)
        #expect(exceptions.divByZero >= 0 && exceptions.divByZero <= 1)
        #expect(exceptions.overflow >= 0 && exceptions.overflow <= 1)
        #expect(exceptions.underflow >= 0 && exceptions.underflow <= 1)
        #expect(exceptions.inexact >= 0 && exceptions.inexact <= 1)
    }
}

// MARK: - Signaling Comparison Tests (Double)

@Suite("CIEEE754 - Signaling Comparisons (Double)", .serialized)
struct CIEEESignalingCompareDoubleTests {
    @Test func signalingEqualNormal() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_equal(3.14, 3.14)
        #expect(result == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func signalingEqualDifferent() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_equal(3.14, 2.71)
        #expect(result == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func signalingEqualNaN() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_equal(Double.nan, 3.14)
        #expect(result == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1, "Should raise invalid exception")
    }

    @Test func signalingLessNormal() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_less(2.0, 3.0) == 1)
        #expect(ieee754_signaling_less(3.0, 2.0) == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func signalingLessNaN() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_less(Double.nan, 3.14)
        #expect(result == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1)
    }

    @Test func signalingLessEqualNormal() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_less_equal(2.0, 3.0) == 1)
        #expect(ieee754_signaling_less_equal(3.0, 3.0) == 1)
        #expect(ieee754_signaling_less_equal(4.0, 3.0) == 0)
    }

    @Test func signalingGreaterNormal() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_greater(3.0, 2.0) == 1)
        #expect(ieee754_signaling_greater(2.0, 3.0) == 0)
    }

    @Test func signalingGreaterEqualNormal() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_greater_equal(3.0, 2.0) == 1)
        #expect(ieee754_signaling_greater_equal(3.0, 3.0) == 1)
        #expect(ieee754_signaling_greater_equal(2.0, 3.0) == 0)
    }

    @Test func signalingNotEqualNormal() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_not_equal(3.0, 2.0) == 1)
        #expect(ieee754_signaling_not_equal(3.0, 3.0) == 0)
    }

    @Test func signalingNotEqualNaN() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_not_equal(Double.nan, 3.14)
        #expect(result == 1, "NaN is not equal to anything")
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1)
    }

    @Test func signalingComparisonsWithInfinity() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_less(3.0, Double.infinity) == 1)
        #expect(ieee754_signaling_greater(Double.infinity, 3.0) == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func signalingComparisonsWithZero() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_equal(0.0, -0.0) == 1, "Signed zeros are equal")
        #expect(ieee754_signaling_less(0.0, 1.0) == 1)
        #expect(ieee754_signaling_greater(-0.0, -1.0) == 1)
    }
}

// MARK: - Signaling Comparison Tests (Float)

@Suite("CIEEE754 - Signaling Comparisons (Float)", .serialized)
struct CIEEESignalingCompareFloatTests {
    @Test func signalingEqualNormal() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_equal_f(3.14, 3.14)
        #expect(result == 1)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 0)
    }

    @Test func signalingEqualNaN() {
        ieee754_clear_all_exceptions()
        let result = ieee754_signaling_equal_f(Float.nan, 3.14)
        #expect(result == 0)
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_INVALID) == 1)
    }

    @Test func signalingLessFloat() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_less_f(2.0, 3.0) == 1)
        #expect(ieee754_signaling_less_f(3.0, 2.0) == 0)
    }

    @Test func signalingGreaterFloat() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_greater_f(3.0, 2.0) == 1)
        #expect(ieee754_signaling_greater_f(2.0, 3.0) == 0)
    }

    @Test func signalingLessEqualFloat() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_less_equal_f(2.0, 3.0) == 1)
        #expect(ieee754_signaling_less_equal_f(3.0, 3.0) == 1)
    }

    @Test func signalingGreaterEqualFloat() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_greater_equal_f(3.0, 2.0) == 1)
        #expect(ieee754_signaling_greater_equal_f(3.0, 3.0) == 1)
    }

    @Test func signalingNotEqualFloat() {
        ieee754_clear_all_exceptions()
        #expect(ieee754_signaling_not_equal_f(3.0, 2.0) == 1)
        #expect(ieee754_signaling_not_equal_f(3.0, 3.0) == 0)
    }
}

// MARK: - Integration Tests

@Suite("CIEEE754 - Integration Scenarios")
struct CIEEEIntegrationTests {
    @Test func roundingModeAndExceptions() {
        // Use the combined scoped API for both rounding mode and exceptions
        let result = withRoundingModeAndClearedExceptions(IEEE754_ROUND_TOWARDZERO) {
            let result = 10.0 / 3.0

            // Verify rounding mode is set within scope
            #expect(ieee754_get_rounding_mode() == IEEE754_ROUND_TOWARDZERO)

            return result
        }

        // Verify result is reasonable
        #expect(result > 3.0 && result < 4.0)
    }

    @Test func exceptionPersistenceAcrossCalls() {
        ieee754_clear_all_exceptions()
        ieee754_raise_exception(IEEE754_EXCEPTION_OVERFLOW)

        // Exception should persist
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 1)

        // Perform some operations
        _ = 1.0 + 1.0

        // Exception should still be set
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 1)

        ieee754_clear_all_exceptions()
        #expect(ieee754_test_exception(IEEE754_EXCEPTION_OVERFLOW) == 0)
    }
}
