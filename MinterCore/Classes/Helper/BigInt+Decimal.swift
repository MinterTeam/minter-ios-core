//
//  BigInt+Decimal.swift
//  AFDateHelper
//
//  Created by Alexey Sidorov on 08/08/2018.
//

import Foundation
import BigInt

public extension BigUInt {
	
	public init?(decimal: Decimal) {
		let formatter = NumberFormatter()
		formatter.generatesDecimalNumbers = true
		formatter.maximumFractionDigits = 18
		guard let string = formatter.string(from: decimal as NSNumber) else {
			return nil
		}
		
		self.init(string)
	}
}
