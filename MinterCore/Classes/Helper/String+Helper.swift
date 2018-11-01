//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


public extension String {
	
	public func stripMinterHexPrefix() -> String {
		if self.hasPrefix("Mx") || self.hasPrefix("mx") || self.hasPrefix("MX") || self.hasPrefix("mX") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
	
	public func stripMinterCheckHexPrefix() -> String {
		if self.hasPrefix("Mc") || self.hasPrefix("mc") || self.hasPrefix("Mc") || self.hasPrefix("mc") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
	
	
}
