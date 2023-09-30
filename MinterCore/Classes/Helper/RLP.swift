import BigInt
import Foundation

public enum RLP {
    enum Error: Swift.Error {
        case encodingError
        case decodingError
    }

    /// Encodes an element as RLP data.
    ///
    /// - Returns: Encoded data or `nil` if the element type is not supported.
    public static func encode(_ element: Any) -> Data? {
        switch element {
        case let string as String:
            return encodeString(string)
        case let list as [Any]:
            return encodeList(list)
        case let number as Int:
            return encodeInt(number)
        case let bigint as BigInt:
            return encodeBigInt(bigint)
        case let biguint as BigUInt:
            return encodeBigUInt(biguint)
        case let data as Data:
            return encodeData(data)
        default:
            return nil
        }
    }

    static func encodeString(_ string: String) -> Data? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return encodeData(data)
    }

    static func encodeInt(_ number: Int) -> Data? {
        guard number >= 0 else {
            return nil // RLP cannot encode negative numbers
        }
        let uint = UInt(bitPattern: number)
        return encodeUInt(uint)
    }

    static func encodeUInt(_ number: UInt) -> Data? {
        let biguint = BigUInt(number)
        return encode(biguint)
    }

    static func encodeBigInt(_ number: BigInt) -> Data? {
        guard number.sign == .plus else {
            return nil // RLP cannot encode negative BigInts
        }
        return encodeBigUInt(number.magnitude)
    }

    static func encodeBigUInt(_ number: BigUInt) -> Data? {
        let encoded = number.serialize()
        if encoded.isEmpty {
            return Data(bytes: [0x80])
        }
        return encodeData(encoded)
    }

    static func encodeData(_ data: Data) -> Data {
        if data.count == 1 && data[0] <= 0x7F {
            // Fits in single byte, no header
            return data
        }

        var encoded = encodeHeader(size: UInt64(data.count), smallTag: 0x80, largeTag: 0xB7)
        encoded.append(data)
        return encoded
    }

    static func encodeList(_ elements: [Any]) -> Data? {
        var encodedData = Data()
        for el in elements {
            guard let encoded = encode(el) else {
                return nil
            }
            encodedData.append(encoded)
        }

        var encoded = encodeHeader(size: UInt64(encodedData.count), smallTag: 0xC0, largeTag: 0xF7)
        encoded.append(encodedData)
        return encoded
    }

    static func encodeHeader(size: UInt64, smallTag: UInt8, largeTag: UInt8) -> Data {
        if size < 56 {
            return Data([smallTag + UInt8(size)])
        }

        let sizeData = putint(size)
        var encoded = Data()
        encoded.append(largeTag + UInt8(sizeData.count))
        encoded.append(contentsOf: sizeData)
        return encoded
    }

    /// Returns the representation of an integer using the least number of bytes needed.
    static func putint(_ i: UInt64) -> Data {
        switch i {
        case 0 ..< (1 << 8):
            return Data([UInt8(i)])
        case 0 ..< (1 << 16):
            return Data([
                UInt8(i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        case 0 ..< (1 << 24):
            return Data([
                UInt8(i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        case 0 ..< (1 << 32):
            return Data([
                UInt8(i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        case 0 ..< (1 << 40):
            return Data([
                UInt8(i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        case 0 ..< (1 << 48):
            return Data([
                UInt8(i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        case 0 ..< (1 << 56):
            return Data([
                UInt8(i >> 48),
                UInt8(truncatingIfNeeded: i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        default:
            return Data([
                UInt8(i >> 56),
                UInt8(truncatingIfNeeded: i >> 48),
                UInt8(truncatingIfNeeded: i >> 40),
                UInt8(truncatingIfNeeded: i >> 32),
                UInt8(truncatingIfNeeded: i >> 24),
                UInt8(truncatingIfNeeded: i >> 16),
                UInt8(truncatingIfNeeded: i >> 8),
                UInt8(truncatingIfNeeded: i),
            ])
        }
    }

    // MARK: - Decode

    public static func decode(_ raw: String) -> RLPItem? {
        let rawData = Data(hex: raw.stripMinterHexPrefix())
        return decode(rawData)
    }

    public static func decode(_ raw: Data) -> RLPItem? {
        if raw.count == 0 {
            return RLPItem.noItem
        }
        var outputArray = [RLPItem]()
        var bytesToParse = Data(raw)
        while bytesToParse.count != 0 {
            let (of, dl, t) = decodeLength(bytesToParse)
            guard let offset = of,
                  let dataLength = dl,
                  let type = t else { return nil }
            switch type {
            case .empty:
                break
            case .data:
                guard let slice = try? slice(data: bytesToParse,
                                             offset: offset,
                                             length: dataLength) else { return nil }
                let data = Data(slice)
                let rlpItem = RLPItem(content: .data(data))
                outputArray.append(rlpItem)
            case .list:
                guard let slice = try? slice(data: bytesToParse, offset: offset, length: dataLength) else { return nil }
                guard let inside = decode(Data(slice)) else { return nil }
                switch inside.content {
                case .data:
                    return nil
                default:
                    outputArray.append(inside)
                }
            }
            guard let tail = try? slice(data: bytesToParse, start: offset + dataLength) else { return nil }
            bytesToParse = tail
        }
        return RLPItem(content: .list(outputArray, 0, Data(raw)))
    }

    public struct RLPItem {
        enum UnderlyingType {
            case empty
            case data
            case list
        }

        public enum RLPContent {
            case noItem
            case data(Data)
            indirect case list([RLPItem], Int, Data)
        }

        public var content: RLPContent

        public var isData: Bool {
            switch content {
            case .noItem:
                return false
            case .data:
                return true
            case .list:
                return false
            }
        }

        public var isList: Bool {
            switch content {
            case .noItem:
                return false
            case .data:
                return false
            case .list:
                return true
            }
        }

        public var count: Int? {
            switch content {
            case .noItem:
                return nil
            case .data:
                return nil
            case let .list(list, _, _):
                return list.count
            }
        }

        //        public var hasNext: Bool {
        //            switch self.content {
        //            case .noItem:
        //                return false
        //            case .data(_):
        //                return false
        //            case .list(let list, let counter, _):
        //                return list.count > counter
        //            }
        //        }

        public subscript(index: Int) -> RLPItem? {
            guard case let .list(list, _, _) = content else { return nil }
            let item = list[index]
            return item
        }

        public var data: Data? {
            return getData()
        }

        public func getData() -> Data? {
            if isList {
                guard case let .list(_, _, rawContent) = content else { return nil }
                return rawContent
            }
            guard case let .data(data) = content else { return nil }
            return data
        }

        public static var noItem: RLPItem {
            return RLPItem(content: .noItem)
        }
    }

    internal static func decodeLength(_ input: Data) -> (offset: BigUInt?, length: BigUInt?, type: RLPItem.UnderlyingType?) {
        do {
            let length = BigUInt(input.count)
            if length == BigUInt(0) {
                return (0, 0, .empty)
            }
            let prefixByte = input[0]
            let exac = prefixByte.subtractingReportingOverflow(0xB7)
            let exac1 = prefixByte.subtractingReportingOverflow(0xC0)
            let exac2 = prefixByte.subtractingReportingOverflow(0xF7)
            if prefixByte <= 0x7F {
                return (BigUInt(0), BigUInt(1), .data)
            } else if prefixByte <= 0xB7, length > BigUInt(prefixByte - 0x80) {
                let dataLength = BigUInt(prefixByte - 0x80)
                return (BigUInt(1), dataLength, .data)
            } else if
                try prefixByte <= 0xBF
                && exac.1 == false
                && length > BigUInt(exac.0)
                && length > BigUInt(exac.0) + toBigUInt(slice(data: input,
                                                              offset: BigUInt(1),
                                                              length: BigUInt(exac.0)))
            {
                let lengthOfLength = BigUInt(prefixByte - 0xB7)
                let dataLength = try toBigUInt(slice(data: input, offset: BigUInt(1), length: BigUInt(prefixByte - 0xB7)))
                return (1 + lengthOfLength, dataLength, .data)
            } else if
                prefixByte <= 0xF7,
                exac1.1 == false,
                length > BigUInt(exac1.0)
            {
                let listLen = BigUInt(prefixByte - 0xC0)
                return (1, listLen, .list)
            } else if
                try prefixByte <= 0xFF
                && exac2.1 == false
                && length > BigUInt(exac2.0)
                && length > BigUInt(exac2.0) + toBigUInt(slice(data: input, offset: BigUInt(1),
                                                               length: BigUInt(exac2.0)))
            {
                let lengthOfListLength = BigUInt(exac2.0)
                let listLength = try toBigUInt(slice(data: input, offset: BigUInt(1),
                                                     length: BigUInt(exac2.0)))
                return (1 + lengthOfListLength, listLength, .list)
            } else {
                return (nil, nil, nil)
            }
        } catch {
            return (nil, nil, nil)
        }
    }

    internal static func slice(data: Data, offset: BigUInt, length: BigUInt) throws -> Data {
        if BigUInt(data.count) < offset + length { throw Error.encodingError }
        let slice = data[UInt64(offset) ..< UInt64(offset + length)]
        return Data(slice)
    }

    internal static func slice(data: Data, start: BigUInt) throws -> Data {
        if BigUInt(data.count) < start { throw Error.encodingError }
        let slice = data[UInt64(start) ..< UInt64(data.count)]
        return Data(slice)
    }

    internal static func toBigUInt(_ raw: Data) throws -> BigUInt {
        if raw.count == 0 {
            throw Error.encodingError
        } else if raw.count == 1 {
            return BigUInt(raw)
        } else {
            let slice = raw[0 ..< raw.count - 1]
            return try BigUInt(raw[raw.count - 1]) + toBigUInt(slice) * 256
        }
    }
}
