//
//  BigInt+Decimal.swift
//  AFDateHelper
//
//  Created by Alexey Sidorov on 08/08/2018.
//

import Foundation
import BigInt

extension BigUInt {
	
	init?(decimal: Decimal) {
		let formatter = NumberFormatter()
		formatter.generatesDecimalNumbers = true
		guard let string = formatter.string(from: decimal as NSNumber) else {
			return nil
		}
		
		self.init(string)
	}
}
