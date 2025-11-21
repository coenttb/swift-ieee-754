// [Double].swift
// swift-ieee-754
//
// Array extensions for Swift standard library Double (IEEE 754 binary64)

import Standards

extension [Double] {
    /// Creates an array of Doubles from a flat byte collection
    ///
    /// Converts a collection of bytes in IEEE 754 binary64 format to an array
    /// of Double values. Each Double requires exactly 8 bytes.
    ///
    /// - Parameters:
    ///   - bytes: Collection of bytes representing multiple Doubles
    ///   - endianness: Byte order of the input bytes (defaults to little-endian)
    /// - Returns: Array of Doubles, or nil if byte count is not a multiple of 8
    ///
    /// Example:
    /// ```swift
    /// let bytes: [UInt8] = [
    ///     0x6E, 0x86, 0x1B, 0xF0, 0xF9, 0x21, 0x09, 0x40,  // 3.14159
    ///     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x3F   // 1.0
    /// ]
    /// let doubles = [Double](bytes: bytes)
    /// // [3.14159, 1.0]
    /// ```
    ///
    /// - Note: Uses ``Double/init(bytes:endianness:)`` under the hood
    public init?<C: Collection>(bytes: C, endianness: [UInt8].Endianness = .little)
    where C.Element == UInt8 {
        let elementSize = MemoryLayout<Element>.size
        guard bytes.count % elementSize == 0 else { return nil }

        var result: [Element] = []
        result.reserveCapacity(bytes.count / elementSize)

        let byteArray: [UInt8] = .init(bytes)
        for i in stride(from: 0, to: byteArray.count, by: elementSize) {
            let chunk: [UInt8] = .init(byteArray[i..<i + elementSize])
            guard let element = Element(bytes: chunk, endianness: endianness) else {
                return nil
            }
            result.append(element)
        }

        self = result
    }
}
