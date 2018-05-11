//
//  Data+HEX.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 30/03/2018.
//

import Foundation
import BigInt

extension Data {
	
	func setLengthLeft(_ toBytes: UInt64, isNegative: Bool = false) -> Data? {
		let existingLength = UInt64(self.count)
		if (existingLength == toBytes) {
			return Data(self)
		} else if (existingLength > toBytes) {
			return nil
		}
		var data:Data
		if (isNegative) {
			data = Data(repeating: UInt8(255), count: Int(toBytes - existingLength))
		} else {
			data = Data(repeating: UInt8(0), count: Int(toBytes - existingLength))
		}
		data.append(self)
		return data
	}
	
	func setLengthRight(_ toBytes: UInt64, isNegative: Bool = false) -> Data? {
		let existingLength = UInt64(self.count)
		if (existingLength == toBytes) {
			return Data(self)
		} else if (existingLength > toBytes) {
			return nil
		}
		var data:Data = Data()
		data.append(self)
		if (isNegative) {
			data.append(Data(repeating: UInt8(255), count: Int(toBytes - existingLength)))
		} else {
			data.append(Data(repeating: UInt8(0), count:Int(toBytes - existingLength)))
		}
		return data
	}
}

public extension Data {
	
	init?(hexString: String) {
		let len = hexString.count / 2
		var data = Data(capacity: len)
		for i in 0..<len {
			let j = hexString.index(hexString.startIndex, offsetBy: i*2)
			let k = hexString.index(j, offsetBy: 2)
			let bytes = hexString[j..<k]
			if var num = UInt8(bytes, radix: 16) {
				data.append(&num, count: 1)
			} else {
				return nil
			}
		}
		self = data
	}
	
	func hexadecimalString() -> String {
		return String(map { String(format: "%02hhx ", $0) }.joined().dropLast())
	}
}


public protocol DataConvertable {
	static func +(lhs: Data, rhs: Self) -> Data
	static func +=(lhs: inout Data, rhs: Self)
}

extension DataConvertable {
	public static func +(lhs: Data, rhs: Self) -> Data {
		var value = rhs
		let data = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
		return lhs + data
	}
	
	public static func +=(lhs: inout Data, rhs: Self) {
		lhs = lhs + rhs
	}
}

extension UInt8: DataConvertable {}
extension UInt32: DataConvertable {}


