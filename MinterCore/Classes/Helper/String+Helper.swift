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
		else if self.hasPrefix("Mt") || self.hasPrefix("mt") || self.hasPrefix("MT") || self.hasPrefix("mT") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		else if self.hasPrefix("Mp") || self.hasPrefix("mp") || self.hasPrefix("MP") || self.hasPrefix("mP") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
	
	public func stripMinterCheckHexPrefix() -> String {
		if self.hasPrefix("Mc") || self.hasPrefix("mc") || self.hasPrefix("MC") || self.hasPrefix("mC") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
	
	
}
