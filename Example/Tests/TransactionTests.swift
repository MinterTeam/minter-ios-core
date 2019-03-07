//
//  TransactionTests.swift
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

class TransactionSpec: BaseQuickSpec {
	
	override func spec() {
		describe("Transaction Model") {
			
			it("can be mapped with empty JSON") {
				let json = [String : Any]()
				
				let model = Mapper<TransactionMappable>().map(JSON: json)
				expect(model).toNot(beNil())
				expect(model?.hash).to(beNil())
				expect(model?.rawTx).to(beNil())
				expect(model?.height).to(beNil())
				expect(model?.index).to(beNil())
				expect(model?.txResult).to(beNil())
				expect(model?.from).to(beNil())
				expect(model?.nonce).to(beNil())
				expect(model?.gasPrice).to(beNil())
				expect(model?.type).to(beNil())
				expect(model?.data).to(beNil())
				expect(model?.payload).to(beNil())
			}
			
			it("can be mapped with Dict") {
				
				let json: [String : Any] = [
					"gas_coin" : "MNT",
					"height" : 125314,
					"data" : [
						"pub_key" : "Mp1043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf2",
						"coin" : "MNT",
						"stake" : "5460000000000000000000",
					],
					"tx_result" : [
						"gas_used" : 100,
						"gas_wanted" : 100,
					],
					"gas_price" : 1,
					"nonce" : 53,
					"raw_tx" : "f88d35018a4d4e540000000000000007b838f7a01043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf28a4d4e54000000000000008a0127fcb8afae20d0000080801ba0bec6139cce8753d0fe7440e86dbfca8dca088462cd206bc06fbb45fa34d677a5a03652ae659c3f518aa920def6e8eadd66ebfa9984bf5ba208772c2c49f9f22251",
					"from" : "Mxd0eff6e8e4bd7e2c803191cdbbba23f547a916d5",
					"payload" : "",
					"hash" : "BC4B144CE8C4DCDEDA06903CC4535C43CE084583",
					"type" : 7,
					"index" : 0
				]
				
				
				let model = Mapper<TransactionMappable>().map(JSON: json)
				expect(model).toNot(beNil())
				expect(model?.hash).to(equal("BC4B144CE8C4DCDEDA06903CC4535C43CE084583"))
		expect(model?.rawTx).to(equal("f88d35018a4d4e540000000000000007b838f7a01043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf28a4d4e54000000000000008a0127fcb8afae20d0000080801ba0bec6139cce8753d0fe7440e86dbfca8dca088462cd206bc06fbb45fa34d677a5a03652ae659c3f518aa920def6e8eadd66ebfa9984bf5ba208772c2c49f9f22251"))
				expect(model?.height).to(equal(125314))
				expect(model?.index).to(equal(0))
				expect(model?.txResult?["gas_used"] as? Int).to(equal(100))
				expect(model?.txResult?["gas_wanted"] as? Int).to(equal(100))
				
				expect(model?.from).to(equal("Mxd0eff6e8e4bd7e2c803191cdbbba23f547a916d5"))
				expect(model?.nonce).to(equal(53))
				expect(model?.gasPrice).to(equal(1))
//				expect(model?.type).to(equal(7))
				expect(model?.data?["pub_key"] as? String).to(contain("Mp1043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf2"))
				expect(model?.data?["coin"] as? String).to(contain("MNT"))
				expect(model?.data?["stake"] as? String).to(contain("5460000000000000000000"))
				expect(model?.payload).to(equal(""))
			}
			
			it("can be mapped with JSON") {
				let JSONString = "{\"hash\": \"BC4B144CE8C4DCDEDA06903CC4535C43CE084583\",\"raw_tx\": \"f88d35018a4d4e540000000000000007b838f7a01043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf28a4d4e54000000000000008a0127fcb8afae20d0000080801ba0bec6139cce8753d0fe7440e86dbfca8dca088462cd206bc06fbb45fa34d677a5a03652ae659c3f518aa920def6e8eadd66ebfa9984bf5ba208772c2c49f9f22251\",\"height\": 125314,\"index\": 0,\"tx_result\": {\"gas_wanted\": 100,\"gas_used\": 100},\"from\": \"Mxd0eff6e8e4bd7e2c803191cdbbba23f547a916d5\",\"nonce\": 53,\"gas_price\": 1,\"gas_coin\": \"MNT\",\"type\": 7,\"data\": {\"pub_key\": \"Mp1043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf2\",\"coin\": \"MNT\",\"stake\": \"5460000000000000000000\"},\"payload\": \"\"}"
				
				let model = Mapper<TransactionMappable>().map(JSONString: JSONString)
				expect(model).toNot(beNil())
				expect(model?.hash).to(equal("BC4B144CE8C4DCDEDA06903CC4535C43CE084583"))
				expect(model?.rawTx).to(equal("f88d35018a4d4e540000000000000007b838f7a01043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf28a4d4e54000000000000008a0127fcb8afae20d0000080801ba0bec6139cce8753d0fe7440e86dbfca8dca088462cd206bc06fbb45fa34d677a5a03652ae659c3f518aa920def6e8eadd66ebfa9984bf5ba208772c2c49f9f22251"))
				expect(model?.height).to(equal(125314))
				expect(model?.index).to(equal(0))
				expect(model?.txResult?["gas_used"] as? Int).to(equal(100))
				expect(model?.txResult?["gas_wanted"] as? Int).to(equal(100))
				expect(model?.from).to(equal("Mxd0eff6e8e4bd7e2c803191cdbbba23f547a916d5"))
				expect(model?.nonce).to(equal(53))
				expect(model?.gasPrice).to(equal(1))
//				expect(model?.type).to(equal(7))
				expect(model?.data?["pub_key"] as? String).to(contain("Mp1043d80d0ba8531e869de04e5698deedc9c15c8baa028fc34fbd82bb2fd76bf2"))
				expect(model?.data?["coin"] as? String).to(contain("MNT"))
				expect(model?.data?["stake"] as? String).to(contain("5460000000000000000000"))
				expect(model?.payload).to(equal(""))
			}
			
		}
	}
	
}
