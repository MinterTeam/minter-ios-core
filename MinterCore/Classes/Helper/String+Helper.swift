//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


public extension String {
	
	public func stripMinterHexPrefix() -> String {
		return self.replacingOccurrences(of: "^(Mx|mx|MX|mX|Mt|mt|MT|mT|Mp|mp|MP|mP)", with: "", options: .regularExpression)
	}
	
	public func stripMinterCheckHexPrefix() -> String {
		return self.replacingOccurrences(of: "^(Mc|mc|MC|mC)", with: "", options: .regularExpression)
	}
	
	
}
