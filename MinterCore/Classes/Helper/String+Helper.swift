//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


extension String {
	
	func stripMinterHexPrefix() -> String {
		if self.hasPrefix("Mx") || self.hasPrefix("mx") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
}
