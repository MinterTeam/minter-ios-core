//
//  AddressTransformerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 13/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class AddressTransformerSpec: QuickSpec {
	
	override func spec() {
		describe("AddressTransformer") {
			
			it("AddressTransformerTests can transform address") {
				
				let adr = "Mx184ac726059e43643e67290666f7b3195093f870"
				
				let transformer = AddressTransformer()
				let val = transformer.transformFromJSON(adr)
				expect(val).to(equal(adr))
				
				let val1 = transformer.transformToJSON(val)
				expect(val).to(equal(val1))
			}
			
			it("AddressTransformerTests can't transform nil") {
				
				let adr: String? = nil
				
				let transformer = AddressTransformer()
				let val = transformer.transformFromJSON(adr)
				expect(val).to(beNil())
			}
			
		}
	}
}
