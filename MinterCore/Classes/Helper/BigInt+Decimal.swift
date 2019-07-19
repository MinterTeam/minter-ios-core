//
//  BigInt+Decimal.swift
//  AFDateHelper
//
//  Created by Alexey Sidorov on 08/08/2018.
//

import Foundation
import BigInt

public extension BigUInt {

	public init?(decimal: Decimal, fromPIP: Bool = false) {

		let amount = fromPIP ? decimal * TransactionCoinFactorDecimal : decimal

		let formatter = NumberFormatter()
		formatter.generatesDecimalNumbers = true
		formatter.maximumFractionDigits = 18
		guard let string = formatter.string(from: amount as NSNumber) else {
			return nil
		}

		self.init(string)
	}
}
