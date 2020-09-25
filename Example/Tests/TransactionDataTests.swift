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

class SendCoinTransactionDataSpec: BaseQuickSpec {
	
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
        "coin" : ["id": 1, "symbol": "MNT"],
				"from" : "Mxc17a3afd805eab5ef3f2bbbc5edd49c28efb4d8c",
				"amount" : "123"
			]

			let model = Mapper<SendCoinTransactionDataMappable>().map(JSON: json)
			expect(model).toNot(beNil())
			expect(model?.to).to(equal("Mxfe60014a6e9ac91618f5d1cab3fd58cded61ee99"))
      expect(model?.coin?.id).to(equal(1))
      expect(model?.coin?.symbol).to(equal("MNT"))
			expect(model?.from).to(equal("Mxc17a3afd805eab5ef3f2bbbc5edd49c28efb4d8c"))
			expect(model?.amount).to(equal(Decimal(123)))
		}

		describe("ConvertTransactionDataMappable Model") {
			it("ConvertTransactionDataMappable can be mapped") {
				let json: [String : Any] = [
          "coin_to_sell" : ["id": 1, "symbol": "MNT"],
					"coin_to_buy": ["id": 2, "symbol": "BELTCOIN"],
					"value" : "1.0",
					"from" : "Mx228e5a68b847d169da439ec15f727f08233a7ca6"]

				let data = ConvertTransactionDataMappable(JSON: json)
        expect(data?.fromCoin?.id).to(equal(1))
        expect(data?.fromCoin?.symbol).to(equal("MNT"))
        expect(data?.toCoin?.id).to(equal(2))
        expect(data?.toCoin?.symbol).to(equal("BELTCOIN"))
				expect(data?.value).to(equal(Decimal(1.0)))
				expect(data?.from).to(equal("Mx228e5a68b847d169da439ec15f727f08233a7ca6"))
			}

			it("ConvertTransactionDataMappable can be mapped") {
				let json: [String : Any] = [
					"coin_to_sell" : "MNT",
					"coin_to_buy": "BELTCOIN",
					"value" : "1.0",
					"from" : "Mx228e5a68b847d169da439ec15f727f08233a7ca6"]

				let data = ConvertTransactionDataMappable(JSON: json)
//				expect(data?.fromCoin).to(equal("MNT"))
//				expect(data?.toCoin).to(equal("BELTCOIN"))
				expect(data?.value).to(equal(Decimal(1.0)))
				expect(data?.from).to(equal("Mx228e5a68b847d169da439ec15f727f08233a7ca6"))
			}
		}
		
		describe("SellAllCoinsTransactionDataMappable Model") {
			it("SellAllCoinsTransactionDataMappable can be mapped") {
				let json: [String : Any] = [
					"coin_to_sell" : "MNT",
					"coin_to_buy": "BELTCOIN",
					"from" : "Mx228e5a68b847d169da439ec15f727f08233a7ca6"]
				
				let data = SellAllCoinsTransactionDataMappable(JSON: json)
//				expect(data?.fromCoin).to(equal("MNT"))
//				expect(data?.toCoin).to(equal("BELTCOIN"))
				expect(data?.from).to(equal("Mx228e5a68b847d169da439ec15f727f08233a7ca6"))
			}
		}
	}
}
