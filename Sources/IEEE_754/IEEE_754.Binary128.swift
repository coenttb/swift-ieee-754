// IEEE_754.Binary128.swift
// swift-ieee-754
//
// IEEE 754-2019: Binary128 (Quadruple Precision) Format
// Format specification and constants (no native Swift type available)

import Standards

extension IEEE_754 {
    /// Binary128 (Quadruple Precision) Format
    ///
    /// 128-bit binary floating-point format per IEEE 754-2019 Section 3.6.
    ///
    /// ## Format Specification (IEEE 754-2019 Section 3.6, Table 3.5)
    ///
    /// Total: 128 bits (16 bytes)
    /// - Sign: 1 bit
    /// - Exponent: 15 bits (biased by 16383)
    /// - Significand: 112 bits (plus implicit leading 1)
    ///
    /// ## Encoding
    ///
    /// ```
    /// seee eeee eeee eeee ffff ... ffff
    /// │└──────┬───────┘ └───────┬──────┘
    /// │    exponent       significand
    /// sign  (15 bits)     (112 bits)
    /// ```
    ///
    /// ## Special Values
    ///
    /// - Zero: exponent = 0, fraction = 0
    /// - Subnormal: exponent = 0, fraction ≠ 0
    /// - Infinity: exponent = 32767, fraction = 0
    /// - NaN: exponent = 32767, fraction ≠ 0
    ///
    /// ## Overview
    ///
    /// Binary128 provides quadruple precision floating-point arithmetic with
    /// approximately 34 decimal digits of precision. This is the largest
    /// standard binary interchange format defined by IEEE 754-2019.
    ///
    /// **Note**: Swift does not currently provide a native binary128 type.
    /// This namespace documents the format specification for reference and
    /// future compatibility.
    ///
    /// ## See Also
    /// - IEEE 754-2019 Section 3.6, Table 3.5
    public enum Binary128 {
        /// Number of bytes in binary128 format (16)
        public static let byteSize: Int = 16

        /// Number of bits in binary128 format (128)
        public static let bitSize: Int = 128

        /// Sign bit: 1 bit
        public static let signBits: Int = 1

        /// Exponent bits: 15 bits
        public static let exponentBits: Int = 15

        /// Significand bits: 112 bits (plus implicit leading 1)
        public static let significandBits: Int = 112

        /// Exponent bias: 16383
        public static let exponentBias: Int = 16383

        /// Maximum exponent value (before bias): 32767
        public static let maxExponent: Int = (1 << exponentBits) - 1

        /// Precision (including implicit bit) - IEEE 754-2019 Table 3.5
        ///
        /// The precision p is the number of significant bits in the significand,
        /// including the implicit leading bit. For binary128, p = 113.
        public static let precision: Int = 113

        /// Minimum exponent - IEEE 754-2019 Table 3.5
        ///
        /// The minimum exponent emin for binary128 is -16382. This is the smallest
        /// exponent for normal numbers.
        public static let emin: Int = -16382

        /// Maximum exponent - IEEE 754-2019 Table 3.5
        ///
        /// The maximum exponent emax for binary128 is 16383. This is the largest
        /// exponent for normal numbers.
        public static let emax: Int = 16383

        /// Decimal precision - IEEE 754-2019 Table 3.5
        ///
        /// Binary128 provides approximately 34 decimal digits of precision.
        public static let decimalPrecision: Int = 34
    }
}

extension IEEE_754.Binary128 {
    /// Documentation: Special values for Binary128
    ///
    /// ## Overview
    ///
    /// IEEE 754 defines several special values for binary128:
    ///
    /// ### Zeros
    /// - Positive zero: sign = 0, exponent = 0, fraction = 0
    /// - Negative zero: sign = 1, exponent = 0, fraction = 0
    ///
    /// ### Infinities
    /// - Positive infinity: sign = 0, exponent = 32767, fraction = 0
    /// - Negative infinity: sign = 1, exponent = 32767, fraction = 0
    ///
    /// ### NaN (Not a Number)
    /// - Quiet NaN: exponent = 32767, fraction ≠ 0, MSB of fraction = 1
    /// - Signaling NaN: exponent = 32767, fraction ≠ 0, MSB of fraction = 0
    ///
    /// **Note**: No Swift type is currently available for binary128.
    ///
    /// ## See Also
    /// - IEEE 754-2019 Section 6.2: Special values
    public enum SpecialValuesDocumentation {}
}
