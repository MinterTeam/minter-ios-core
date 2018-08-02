//
//  AddressTransformer.swift
//  MinterExplorer
//
//  Created by Alexey Sidorov on 04/07/2018.
//

import Foundation
import ObjectMapper


public class AddressTransformer : TransformType {
	
	public init() {}
	
	public typealias Object = String
	
	public typealias JSON = String
	
	public func transformFromJSON(_ value: Any?) -> Object? {
		if let val = value as? String {
			return "Mx" + val.stripMinterHexPrefix().lowercased()
		}
		return nil
	}
	
	public func transformToJSON(_ value: Object?) -> JSON? {
		return value
	}
	
	
}

