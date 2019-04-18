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
				let coin = "MNT"
				let data = "data".data(using: .utf8)!
				
				let gasCoin = coin.data(using: .utf8)!.setLengthRight(10)!
				
				let model = DelegateRawTransaction(nonce: nonce, chainId: 2, gasCoin: coin, data: data)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoin).to(equal(gasCoin))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let coin = "MNT"
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)
				
				let gasCoin = coin.data(using: .utf8)!.setLengthRight(10)!
				
				let data = RLP.encode([Data(hex: publicKey), gasCoin, value])
				
				let model = DelegateRawTransaction(nonce: nonce, chainId: 2, gasCoin: coin, publicKey: publicKey, coin: coin, value: value)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.gasCoin).to(equal(gasCoin))
			}
			
			it("Can be initialized") {
				let coin = "MNT"
				let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let value = BigUInt(2)
				
				let gasCoin = coin.data(using: .utf8)!.setLengthRight(10)!
				
				let model = DelegateRawTransactionData(publicKey: publicKey, coin: coin, value: value)
				
				let encoded = try? JSONEncoder().encode(model)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(DelegateRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.publicKey).to(equal(publicKey))
				expect(decoded?.coin).to(equal(coin))
				expect(decoded?.value).to(equal(value))
			}
			
		}
	}
}
