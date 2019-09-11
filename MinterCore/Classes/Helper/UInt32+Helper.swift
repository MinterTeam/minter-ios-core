//
//  UInt32+Helper.swift
//  Minter
//
//  Created by Alexey Sidorov on 14/05/2018.
//

import Foundation

extension UInt32 {

	init<T: Collection>(bytes: T, fromIndex index: T.Index) where T.Element == UInt8, T.Index == Int {
		if bytes.isEmpty {
			self = 0
			return
		}

		let count = bytes.count

		let val0 = count > 0 ? UInt32(bytes[index.advanced(by: 0)]) << 24 : 0
		let val1 = count > 1 ? UInt32(bytes[index.advanced(by: 1)]) << 16 : 0
		let val2 = count > 2 ? UInt32(bytes[index.advanced(by: 2)]) << 8 : 0
		let val3 = count > 3 ? UInt32(bytes[index.advanced(by: 3)]) : 0
		self = val0 | val1 | val2 | val3
	}

}
