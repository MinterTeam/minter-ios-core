//
//  RLP.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 16/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

import Foundation
import BigInt

protocol ArrayType {}
extension Array : ArrayType {}

struct RLP1 {
	static var length56 = BigUInt(UInt(56))
	static var lengthMax = (BigUInt(UInt(1)) << 256)
	
	static func encode(_ element: AnyObject) -> Data? {
		if let string = element as? String {
			return encode(string)
			
		} else if let data = element as? Data {
			return encode(data)
		}
		else if let biguint = element as? BigUInt {
			return encode(biguint)
		}
		return nil;
	}
	
	internal static func encode(_ string: String) -> Data? {
		if let hexData = Data.fromHex(string) {
			return encode(hexData)
		}
		guard let data = string.data(using: .utf8) else {return nil}
		return encode(data)
	}
	
	internal static func encode(_ number: Int) -> Data? {
		guard number >= 0 else {return nil}
		let uint = UInt(number)
		return encode(uint)
	}
	
	internal static func encode(_ number: UInt) -> Data? {
		let biguint = BigUInt(number)
		return encode(biguint)
	}
	
	internal static func encode(_ number: BigUInt) -> Data? {
		let encoded = number.serialize()
		return encode(encoded)
	}
	
	//    internal static func encode(_ unstrippedData: Data) -> Data? {
	//        var startIndex = 0;
	//        for i in 0..<unstrippedData.count{
	//            if unstrippedData[i] != 0x00 {
	//                startIndex = i
	//                break
	//            }
	//        }
	//        let data = unstrippedData[startIndex ..< unstrippedData.count]
	internal static func encode(_ data: Data) -> Data? {
		if (data.count == 1 && data.bytes[0] < UInt8(0x80)) {
			return data
		} else {
			guard let length = encodeLength(data.count, offset: UInt8(0x80)) else {return nil}
			var encoded = Data()
			encoded.append(length)
			encoded.append(data)
			return encoded
		}
	}
	
	internal static func encodeLength(_ length: Int, offset: UInt8) -> Data? {
		if (length < 0) {
			return nil;
		}
		let bigintLength = BigUInt(UInt(length))
		return encodeLength(bigintLength, offset: offset)
	}
	
	internal static func encodeLength(_ length: BigUInt, offset: UInt8) -> Data? {
		if (length < length56) {
			let encodedLength = length + BigUInt(UInt(offset))
			guard (encodedLength.bitWidth <= 8) else {return nil}
			return encodedLength.serialize()
		} else if (length < lengthMax) {
			let encodedLength = length.serialize()
			let len = BigUInt(UInt(encodedLength.count))
			guard let prefix = lengthToBinary(len) else {return nil}
			let lengthPrefix = prefix + offset + UInt8(55)
			var encoded = Data([lengthPrefix])
			encoded.append(encodedLength)
			return encoded
		}
		return nil
	}
	
	internal static func lengthToBinary(_ length: BigUInt) -> UInt8? {
		if (length == 0) {
			return UInt8(0)
		}
		let divisor = BigUInt(256)
		var encoded = Data()
		guard let prefix = lengthToBinary(length/divisor) else {return nil}
		let suffix = length % divisor
		
		var prefixData = Data([prefix])
		if (prefix == UInt8(0)) {
			prefixData = Data()
		}
		let suffixData = suffix.serialize()
		
		encoded.append(prefixData)
		encoded.append(suffixData)
		guard encoded.count == 1 else {return nil}
		return encoded.bytes[0]
	}
	
	static func encode(_ elements: Array<AnyObject>) -> Data? {
		var encodedData = Data()
		for e in elements {
			guard let encoded = encode(e) else {return nil}
			encodedData.append(encoded)
		}
		guard var encodedLength = encodeLength(encodedData.count, offset: UInt8(0xc0)) else {
			
			return nil
		}
		if (encodedLength != Data()) {
			encodedLength.append(encodedData)
		}
		return encodedLength
	}
	
	static func encode(_ elements: [Any]) -> Data? {
		var encodedData = Data()
		for el in elements {
			let e = el as AnyObject
			guard let encoded = encode(e) else {
				
				return nil
			}
			encodedData.append(encoded)
		}
		guard var encodedLength = encodeLength(encodedData.count, offset: UInt8(0xc0)) else {return nil}
		if (encodedLength != Data()) {
			encodedLength.append(encodedData)
		}
		return encodedLength
	}
}

public struct RLP {
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
		if data.count == 1 && data[0] <= 0x7f {
			// Fits in single byte, no header
			return data
		}
		
		var encoded = encodeHeader(size: UInt64(data.count), smallTag: 0x80, largeTag: 0xb7)
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
		
		var encoded = encodeHeader(size: UInt64(encodedData.count), smallTag: 0xc0, largeTag: 0xf7)
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
}
