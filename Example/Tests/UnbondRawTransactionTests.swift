//
//  UnbondRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper
import BigInt


class UnbondRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("UnbondRawTransaction Model") {
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let coin = Coin.baseCoin().id!
				let data = "data".data(using: .utf8)!
				
				let model = UnbondRawTransaction(nonce: nonce, chainId: 2, gasCoinId: coin, data: data)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoinId).to(equal(coin))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let coin = Coin.baseCoin().id!
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)

				let data = RLP.encode([Data(hex: publicKey), coin, value])
				
				let model = UnbondRawTransaction(nonce: nonce, chainId: 2, gasCoinId: coin, publicKey: publicKey, coinId: coin, value: value)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoinId).to(equal(coin))
			}
			
			it("Can be initialized") {
				let coin = Coin.baseCoin().id!
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)
				
				let model = UnbondRawTransactionData(publicKey: publicKey, coinId: coin, value: value)
				
				let encoded = try? JSONEncoder().encode(model)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(UnbondRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.publicKey).to(equal(publicKey))
				expect(decoded?.coinId).to(equal(coin))
				expect(decoded?.value).to(equal(value))
			}
			
		}
	}
}
