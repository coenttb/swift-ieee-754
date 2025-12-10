// [Float].swift
// swift-ieee-754
//
// Array extensions for Swift standard library Float (IEEE 754 binary32)

public import Binary
import Standards

extension [Float] {
    /// Creates an array of Floats from a flat byte collection
    ///
    /// Converts a collection of bytes in IEEE 754 binary32 format to an array
    /// of Float values. Each Float requires exactly 4 bytes.
    ///
    /// - Parameters:
    ///   - bytes: Collection of bytes representing multiple Floats
    ///   - endianness: Byte order of the input bytes (defaults to little-endian)
    /// - Returns: Array of Floats, or nil if byte count is not a multiple of 4
    ///
    /// Example:
    /// ```swift
    /// let bytes: [UInt8] = [
    ///     0xD0, 0x0F, 0x49, 0x40,  // 3.14159
    ///     0x00, 0x00, 0x80, 0x3F   // 1.0
    /// ]
    /// let floats = [Float](bytes: bytes)
    /// // [3.14159, 1.0]
    /// ```
    ///
    /// Edge cases:
    /// - Empty byte arrays return an empty array (vacuous truth semantics)
    /// - Invalid byte counts (not divisible by 4) return `nil`
    ///
    /// - Note: Uses ``Float/init(bytes:endianness:)`` under the hood
    public init?<C: Collection>(bytes: C, endianness: Binary.Endianness = .little)
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
