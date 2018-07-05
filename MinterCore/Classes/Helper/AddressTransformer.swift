//
//  AddressTransformer.swift
//  MinterExplorer
//
//  Created by Alexey Sidorov on 04/07/2018.
//

import Foundation
import ObjectMapper


class AddressTransformer : TransformType {
	
	typealias Object = String
	
	typealias JSON = String
	
	func transformFromJSON(_ value: Any?) -> Object? {
		if let val = value as? String {
			return "Mx" + val.stripMinterHexPrefix()
		}
		return nil
	}
	
	func transformToJSON(_ value: Object?) -> JSON? {
		return value
	}
	
	
}

