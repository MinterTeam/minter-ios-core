//
//  SellCoinRawTransactionTests.swift
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

class SellCoinRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = Coin.baseCoin().id!
				let data = "data".data(using: .utf8)!
				let nonce = BigUInt(1)
				let tx = SellCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, data: data)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoinId).to(equal(gasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = Coin.baseCoin().id!
				let nonce = BigUInt(1)
				let coinFrom = Coin.baseCoin().id!
				let coinTo = 1
				let value = BigUInt(1)
				let minimumValue = BigUInt(0)
				let tx = SellCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, coinFromId: coinFrom, coinToId: coinTo, value: value, minimumValueToBuy: minimumValue)
				
				let data = SellCoinRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, value: value, minimumValueToBuy: minimumValue).encode()!
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoinId).to(equal(gasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be encoded/decoded") {
			it("Base initializer") {
				let coinFrom = Coin.baseCoin().id!
				let coinTo = 1
				let value = BigUInt(1)
				let minimumValue = BigUInt(0)
				let data = SellCoinRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, value: value, minimumValueToBuy: minimumValue)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SellCoinRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.coinFromId).to(equal(coinFrom))
				expect(decoded?.coinToId).to(equal(coinTo))
				expect(decoded?.value).to(equal(value))
				expect(decoded?.minimumValueToBuy).to(equal(minimumValue))
			}
		}
	}
	
}

class SellAllCoinRawTransactionTestsSpec: QuickSpec {
	
	override func spec() {
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = Coin.baseCoin().id!
				let data = "data".data(using: .utf8)!
				let nonce = BigUInt(1)
				let tx = SellAllCoinsRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, data: data)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoinId).to(equal(gasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = Coin.baseCoin().id!
				let nonce = BigUInt(1)
				let coinFrom = Coin.baseCoin().id!
				let coinTo = 1
				let minimumValue = BigUInt(0)
				
				let tx = SellAllCoinsRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, coinFromId: coinFrom, coinToId: coinTo, minimumValueToBuy: minimumValue)
				
				let data = SellAllCoinsRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, minimumValueToBuy: minimumValue).encode()!
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoinId).to(equal(gasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be encoded/decoded") {
			it("Base initializer") {
				let coinFrom = Coin.baseCoin().id!
				let coinTo = 1
				let minimumValue = BigUInt(0)
				let data = SellAllCoinsRawTransactionData(coinFromId: coinFrom, coinToId: coinTo, minimumValueToBuy: minimumValue)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SellAllCoinsRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.coinFromId).to(equal(coinFrom))
				expect(decoded?.coinToId).to(equal(coinTo))
				expect(decoded?.minimumValueToBuy).to(equal(minimumValue))
			}
		}
	}
}
