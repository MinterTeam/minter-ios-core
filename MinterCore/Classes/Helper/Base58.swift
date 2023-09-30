//
//  Base58.swift
//  Minter
//
//  Created by Alexey Sidorov on 06/05/2018.
//

import CryptoSwift
import Foundation

extension String {
    func dataWithHexString() -> Data {
        var hex = self
        var data = Data()
        while hex.characters.count > 0 {
            let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}

public extension Data {
    var fullHexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}

enum Base58 {
    static let base58Alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

    // Encode
    static func base58FromBytes(_ bytes: [UInt8]) -> String {
        var bytes = bytes
        var zerosCount = 0
        var length = 0

        for b in bytes {
            if b != 0 { break }
            zerosCount += 1
        }

        bytes.removeFirst(zerosCount)

        let size = bytes.count * 138 / 100 + 1

        var base58: [UInt8] = Array(repeating: 0, count: size)
        for b in bytes {
            var carry = Int(b)
            var i = 0

            for j in 0 ... base58.count - 1 where carry != 0 || i < length {
                carry += 256 * Int(base58[base58.count - j - 1])
                base58[base58.count - j - 1] = UInt8(carry % 58)
                carry /= 58
                i += 1
            }

            assert(carry == 0)

            length = i
        }

        // skip leading zeros
        var zerosToRemove = 0
        var str = ""
        for b in base58 {
            if b != 0 { break }
            zerosToRemove += 1
        }
        base58.removeFirst(zerosToRemove)

        while zerosCount > 0 {
            str = "\(str)1"
            zerosCount -= 1
        }

        for b in base58 {
            str = "\(str)\(base58Alphabet[String.Index(encodedOffset: Int(b))])"
        }

        return str
    }

    // Decode
    static func bytesFromBase58(_ base58: String) -> [UInt8] {
        // remove leading and trailing whitespaces
        var string = base58.trimmingCharacters(in: CharacterSet.whitespaces)

        guard !string.isEmpty else { return [] }

        var zerosCount = 0
        var length = 0
        for c in string.characters {
            if c != "1" { break }
            zerosCount += 1
        }

        let size = string.lengthOfBytes(using: String.Encoding.utf8) * 733 / 1000 + 1 - zerosCount
        var base58: [UInt8] = Array(repeating: 0, count: size)
        for c in string.characters where c != " " {
            // search for base58 character
            guard let base58Index = base58Alphabet.index(of: c) else { return [] }

            var carry = base58Index.encodedOffset
            var i = 0
            for j in 0 ... base58.count where carry != 0 || i < length {
                carry += 58 * Int(base58[base58.count - j - 1])
                base58[base58.count - j - 1] = UInt8(carry % 256)
                carry /= 256
                i += 1
            }

            assert(carry == 0)
            length = i
        }

        // skip leading zeros
        var zerosToRemove = 0

        for b in base58 {
            if b != 0 { break }
            zerosToRemove += 1
        }
        base58.removeFirst(zerosToRemove)

        var result: [UInt8] = Array(repeating: 0, count: zerosCount)
        for b in base58 {
            result.append(b)
        }
        return result
    }
}

public extension Array where Element == UInt8 {
    var base58EncodedString: String {
        guard !isEmpty else { return "" }
        return Base58.base58FromBytes(self)
    }

    var base58CheckEncodedString: String {
        var bytes = self
        let checksum = [UInt8](bytes.sha256().sha256()[0 ..< 4])

        bytes.append(contentsOf: checksum)

        return Base58.base58FromBytes(bytes)
    }
}

public extension String {
    var base58EncodedString: String {
        return [UInt8](utf8).base58EncodedString
    }

    var base58DecodedData: Data? {
        let bytes = Base58.bytesFromBase58(self)
        return Data(bytes)
    }

    var base58CheckDecodedData: Data? {
        guard let bytes = base58CheckDecodedBytes else { return nil }
        return Data(bytes)
    }

    var base58CheckDecodedBytes: [UInt8]? {
        var bytes = Base58.bytesFromBase58(self)
        guard bytes.count >= 4 else { return nil }

        let checksum = [UInt8](bytes[bytes.count - 4 ..< bytes.count])
        bytes = [UInt8](bytes[0 ..< bytes.count - 4])

        let calculatedChecksum = [UInt8](bytes.sha256().sha256()[0 ... 3])
        if checksum != calculatedChecksum { return nil }

        return bytes
    }

    //	public var littleEndianHexToUInt: UInt {
    //		return UInt(self.dataWithHexString().bytes.reversed().fullHexString, radix: 16)!
    //	}
}
