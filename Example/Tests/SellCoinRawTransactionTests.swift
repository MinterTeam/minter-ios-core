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
				let gasCoin = "gasCoin"
				let data = "data".data(using: .utf8)!
				let nonce = BigUInt(1)
				let tx = SellCoinRawTransaction(nonce: nonce, gasCoin: gasCoin, data: data)
				
				let correctGasCoin = gasCoin.data(using: .utf8)!.setLengthRight(10)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoin).to(equal(correctGasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = "gasCoin"
				let nonce = BigUInt(1)
				let coinFrom = "MNT"
				let coinTo = "BPM"
				let value = BigUInt(1)
				let minimumValue = BigUInt(0)
				let tx = SellCoinRawTransaction(nonce: nonce, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, value: value, minimumValueToBuy: minimumValue)
				
				let data = SellCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, minimumValueToBuy: minimumValue).encode()!
				
				let correctGasCoin = gasCoin.data(using: .utf8)!.setLengthRight(10)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoin).to(equal(correctGasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be encoded/decoded") {
			it("Base initializer") {
				let coinFrom = "MNT"
				let coinTo = "BPM"
				let value = BigUInt(1)
				let minimumValue = BigUInt(0)
				let data = SellCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, minimumValueToBuy: minimumValue)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SellCoinRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.coinFrom).to(equal(coinFrom))
				expect(decoded?.coinTo).to(equal(coinTo))
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
				let gasCoin = "gasCoin"
				let data = "data".data(using: .utf8)!
				let nonce = BigUInt(1)
				let tx = SellAllCoinsRawTransaction(nonce: nonce, gasCoin: gasCoin, data: data)
				
				let correctGasCoin = gasCoin.data(using: .utf8)!.setLengthRight(10)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoin).to(equal(correctGasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be initialized") {
			it("Base initializer") {
				let gasCoin = "gasCoin"
				let nonce = BigUInt(1)
				let coinFrom = "MNT"
				let coinTo = "BPM"
				let minimumValue = BigUInt(0)
				
				let tx = SellAllCoinsRawTransaction(nonce: nonce, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, minimumValueToBuy: minimumValue)
				
				let data = SellAllCoinsRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, minimumValueToBuy: minimumValue).encode()!
				
				let correctGasCoin = gasCoin.data(using: .utf8)!.setLengthRight(10)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.gasCoin).to(equal(correctGasCoin))
				expect(tx.data).to(equal(data))
			}
		}
		
		describe("Can be encoded/decoded") {
			it("Base initializer") {
				let coinFrom = "MNT"
				let coinTo = "BPM"
				let minimumValue = BigUInt(0)
				let data = SellAllCoinsRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, minimumValueToBuy: minimumValue)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SellAllCoinsRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.coinFrom).to(equal(coinFrom))
				expect(decoded?.coinTo).to(equal(coinTo))
				expect(decoded?.minimumValueToBuy).to(equal(minimumValue))
			}
		}
	}
}
