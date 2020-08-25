//
//  CoinTests.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 30/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class CoinSpec: BaseQuickSpec {

	override func spec() {
		describe("Coin Model") {
			
			it("can be mapped with empty JSON") {
				let json = [String : Any]()
				
				let model = Mapper<CoinMappable>().map(JSON: json)
				expect(model).toNot(beNil())
				expect(model?.name).to(beNil())
				expect(model?.symbol).to(beNil())
			}
			
			it("Base Coin exists") {
				let model = Coin.baseCoin()
				expect(model).toNot(beNil())
			}

			it("can be mapped with Dict") {
				let json: [String: Any] = [
          "id": 1,
					"reserve_balance" : "395005853441855252801391",
					"symbol" : "SHSCOIN",
					"volume" : "1987475416525182163966830",
					"name" : "Stakeholder Coin",
					"crr" : "50",
					"owner_address" : "Mx6eadf5badeda8f76fc35e0c4d7f7fbc00fe34315"
				]

				let model = Mapper<CoinMappable>().map(JSON: json)
				expect(model).toNot(beNil())
        expect(model?.id).to(equal(1))
				expect(model?.reserveBalance).to(equal(Decimal(string: "395005853441855252801391")!))
				expect(model?.symbol).to(equal("SHSCOIN"))
				expect(model?.name).to(equal("Stakeholder Coin"))
				expect(model?.crr).to(equal("50"))
				expect(model?.ownerAddress).to(equal("Mx6eadf5badeda8f76fc35e0c4d7f7fbc00fe34315"))
			}

			it("can be mapped with JSON") {
        let JSONString = """
{\
          \"id\": 1,\
          \"name\": \"\",\
          \"symbol\": \"KLIM\",\
          \"volume\": \"1000000000000000000\",\
          \"crr\": \"10\",\
          \"reserve_balance\": \"10000000000000000000000\",\
          \"max_supply\": \"10000000000000000000\",\
          \"owner_address\": \"Mx6ab3a04c2f4d6022163f36a73840980cc8fc6a8b\"\
        }
"""

				let model = Mapper<CoinMappable>().map(JSONString: JSONString)
				expect(model).toNot(beNil())
        expect(model?.id).to(equal(1))
				expect(model?.reserveBalance).to(equal(Decimal(string: "10000000000000000000000")!))
				expect(model?.symbol).to(equal("KLIM"))
				expect(model?.name).to(equal(""))
				expect(model?.crr).to(equal("10"))
				expect(model?.ownerAddress).to(equal("Mx6ab3a04c2f4d6022163f36a73840980cc8fc6a8b"))
			}

		}
	}

}
