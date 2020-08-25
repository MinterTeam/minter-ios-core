//
//  DelegateRawTransactionTests.swift
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


class DelegateRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("DelegateRawTransaction Model") {
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let data = "data".data(using: .utf8)!
				let gasCoin = Coin.baseCoin().id!

				let model = DelegateRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, data: data)

				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoinId).to(equal(gasCoin))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let coinId = Coin.baseCoin().id!
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)
				
				let gasCoin = Coin.baseCoin().id!
				
				let data = RLP.encode([Data(hex: publicKey), gasCoin, value])
				
				let model = DelegateRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, publicKey: publicKey, coinId: coinId, value: value)

				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoinId).to(equal(gasCoin))
			}
			
			it("Can be initialized") {
				let coinId = Coin.baseCoin().id!
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)

				let model = DelegateRawTransactionData(publicKey: publicKey, coinId: coinId, value: value)
				
				let encoded = try? JSONEncoder().encode(model)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(DelegateRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())

				expect(decoded?.publicKey).to(equal(publicKey))
				expect(decoded?.coinId).to(equal(coinId))
				expect(decoded?.value).to(equal(value))
			}
			
		}
	}
}
