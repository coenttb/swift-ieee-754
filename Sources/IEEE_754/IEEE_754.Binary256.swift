// IEEE_754.Binary256.swift
// swift-ieee-754
//
// IEEE 754-2019: Binary256 (Octuple Precision) Format
// Format specification and constants (no native Swift type available)

import Standards

extension IEEE_754 {
    /// Binary256 (Octuple Precision) Format
    ///
    /// 256-bit binary floating-point format per IEEE 754-2019 Section 3.6.
    ///
    /// ## Format Specification (IEEE 754-2019 Section 3.6, Table 3.5)
    ///
    /// Total: 256 bits (32 bytes)
    /// - Sign: 1 bit
    /// - Exponent: 19 bits (biased by 262143)
    /// - Significand: 236 bits (plus implicit leading 1)
    ///
    /// ## Encoding
    ///
    /// ```
    /// seee eeee eeee eeee eeee ffff ... ffff
    /// │└──────────┬────────────┘ └──────┬──────┘
    /// │        exponent          significand
    /// sign      (19 bits)        (236 bits)
    /// ```
    ///
    /// ## Special Values
    ///
    /// - Zero: exponent = 0, fraction = 0
    /// - Subnormal: exponent = 0, fraction ≠ 0
    /// - Infinity: exponent = 524287, fraction = 0
    /// - NaN: exponent = 524287, fraction ≠ 0
    ///
    /// ## Overview
    ///
    /// Binary256 provides octuple precision floating-point arithmetic with
    /// approximately 71 decimal digits of precision. This is the largest
    /// extended binary format commonly referenced in IEEE 754-2019.
    ///
    /// **Note**: Swift does not currently provide a native binary256 type.
    /// This namespace documents the format specification for reference and
    /// future compatibility.
    ///
    /// ## See Also
    /// - IEEE 754-2019 Section 3.6, Table 3.5
    public enum Binary256 {
        /// Number of bytes in binary256 format (32)
        public static let byteSize: Int = 32

        /// Number of bits in binary256 format (256)
        public static let bitSize: Int = 256

        /// Sign bit: 1 bit
        public static let signBits: Int = 1

        /// Exponent bits: 19 bits
        public static let exponentBits: Int = 19

        /// Significand bits: 236 bits (plus implicit leading 1)
        public static let significandBits: Int = 236

        /// Exponent bias: 262143
        public static let exponentBias: Int = 262143

        /// Maximum exponent value (before bias): 524287
        public static let maxExponent: Int = (1 << exponentBits) - 1

        /// Precision (including implicit bit) - IEEE 754-2019 Table 3.5
        ///
        /// The precision p is the number of significant bits in the significand,
        /// including the implicit leading bit. For binary256, p = 237.
        public static let precision: Int = 237

        /// Minimum exponent - IEEE 754-2019 Table 3.5
        ///
        /// The minimum exponent emin for binary256 is -262142. This is the smallest
        /// exponent for normal numbers.
        public static let emin: Int = -262142

        /// Maximum exponent - IEEE 754-2019 Table 3.5
        ///
        /// The maximum exponent emax for binary256 is 262143. This is the largest
        /// exponent for normal numbers.
        public static let emax: Int = 262143

        /// Decimal precision - IEEE 754-2019 Table 3.5
        ///
        /// Binary256 provides approximately 71 decimal digits of precision.
        public static let decimalPrecision: Int = 71
    }
}

extension IEEE_754.Binary256 {
    /// Documentation: Special values for Binary256
    ///
    /// ## Overview
    ///
    /// IEEE 754 defines several special values for binary256:
    ///
    /// ### Zeros
    /// - Positive zero: sign = 0, exponent = 0, fraction = 0
    /// - Negative zero: sign = 1, exponent = 0, fraction = 0
    ///
    /// ### Infinities
    /// - Positive infinity: sign = 0, exponent = 524287, fraction = 0
    /// - Negative infinity: sign = 1, exponent = 524287, fraction = 0
    ///
    /// ### NaN (Not a Number)
    /// - Quiet NaN: exponent = 524287, fraction ≠ 0, MSB of fraction = 1
    /// - Signaling NaN: exponent = 524287, fraction ≠ 0, MSB of fraction = 0
    ///
    /// **Note**: No Swift type is currently available for binary256.
    ///
    /// ## See Also
    /// - IEEE 754-2019 Section 6.2: Special values
    public enum SpecialValuesDocumentation {}
}
