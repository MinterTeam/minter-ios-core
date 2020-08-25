//
//  BuyCoinRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 11/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import BigInt

class BuyCoinRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("Can be initialized") {
			let gasCoin = Coin.baseCoin().id!
			let data = "data".data(using: .utf8)!
			let nonce = BigUInt(1)
			let tx = BuyCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, data: data)
			
			expect(tx).toNot(beNil())
			expect(tx.nonce).to(equal(nonce))
			expect(tx.gasCoinId).to(equal(gasCoin))
			expect(tx.data).to(equal(data))
		}
		
		describe("Can be initialized") {
			let gasCoin = Coin.baseCoin().id!
			let nonce = BigUInt(1)
			let coinFrom = Coin.baseCoin().id!
			let coinTo = 1
			let value = BigUInt(1)
			let maximumValue = BigUInt(0)
			let tx = BuyCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, coinFromId: coinFrom, coinToId: coinTo, value: value, maximumValueToSell: maximumValue)
			
			let data = BuyCoinRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, value: value, maximumValueToSell: maximumValue).encode()!
			
			expect(tx).toNot(beNil())
			expect(tx.nonce).to(equal(nonce))
			expect(tx.gasCoinId).to(equal(gasCoin))
			expect(tx.data).to(equal(data))
		}
		
		describe("Can be encoded/decoded") {
			let coinFrom = Coin.baseCoin().id!
			let coinTo = 1
			let value = BigUInt(1)
			let maximumValue = BigUInt(0)
			let data = BuyCoinRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, value: value, maximumValueToSell: maximumValue)
			
			let encoded = try? JSONEncoder().encode(data)
			expect(encoded).toNot(beNil())
			
			let decoded = try? JSONDecoder().decode(BuyCoinRawTransactionData.self, from: encoded!)
			expect(decoded).toNot(beNil())
			
			expect(decoded?.coinFromId).to(equal(coinFrom))
			expect(decoded?.coinToId).to(equal(coinTo))
			expect(decoded?.value).to(equal(value))
			expect(decoded?.maximumValueToSell).to(equal(maximumValue))
		}
	}
}
