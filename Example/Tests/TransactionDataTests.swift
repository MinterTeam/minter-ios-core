//
//  TransactionDataTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 31/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation


import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class SendCoinTransactionDataSpec: QuickSpec {
	
	override func spec() {
		describe("SendCoinTransactionData Model") {
			
			it("can be mapped with empty JSON") {
				let json = [String : Any]()
				
				let model = Mapper<SendCoinTransactionDataMappable>().map(JSON: json)
				expect(model).toNot(beNil())
				expect(model?.coin).to(beNil())
				expect(model?.amount).to(beNil())
				expect(model?.from).to(beNil())
				expect(model?.to).to(beNil())
			}
		}
		
		describe("SendCoinTransactionData Model") {
			let json: [String : Any] = [
				"to" : "Mxfe60014a6e9ac91618f5d1cab3fd58cded61ee99",
				"coin" : "MNT",
				"from" : "Mxc17a3afd805eab5ef3f2bbbc5edd49c28efb4d8c",
				"amount" : "123",
			]
			
			
			let model = Mapper<SendCoinTransactionDataMappable>().map(JSON: json)
			expect(model).toNot(beNil())
			expect(model?.to).to(equal("Mxfe60014a6e9ac91618f5d1cab3fd58cded61ee99"))
			expect(model?.coin).to(equal("MNT"))
			expect(model?.from).to(equal("Mxc17a3afd805eab5ef3f2bbbc5edd49c28efb4d8c"))
			expect(model?.amount).to(equal(Decimal(123)))
		}
	}
}
