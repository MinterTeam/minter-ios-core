//
//  SendCoinRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 17/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper
import BigInt


class SendCoinRawTransactionSpec: BaseQuickSpec {
	
	override func spec() {
		describe("SendCoinRawTransaction Model") {
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let to = "MxAddress"
				let value = BigUInt(1)
				let gasCoin = "MNT".data(using: .utf8)!.setLengthRight(10)!
				
				let txData = SendCoinRawTransactionData(to: to, value: value, coin: "MNT").encode()!
				let tx = SendCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", to: to, value: value, coin: "MNT")
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.data).to(equal(txData))
				expect(tx.gasCoin).to(equal(gasCoin))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let to = "MxAddress"
				let value = BigUInt(1)
				let rawCoin = "MNT"
				let gasCoin = rawCoin.data(using: .utf8)!.setLengthRight(10)!
				
				let txData = SendCoinRawTransactionData(to: to, value: value, coin: rawCoin).encode()!
				let tx = SendCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: rawCoin, data: txData)
				
				expect(tx).toNot(beNil())
				expect(tx.nonce).to(equal(nonce))
				expect(tx.data).to(equal(txData))
				expect(tx.gasCoin).to(equal(gasCoin))
			}
			
			it("Can be encoded") {
				let to = "MxAddress"
				let value = BigUInt(1)
				let coin = "MNT"
				let data = SendCoinRawTransactionData(to: to, value: value, coin: coin)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SendCoinRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.to).to(equal(to))
				expect(decoded?.value).to(equal(value))
				expect(decoded?.coin).to(equal(coin))
			}
			
		}
	}
}
