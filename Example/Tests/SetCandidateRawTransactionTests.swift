//
//  SetCandidateRawTransactionTests.swift
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


class SetCandidateRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("SetCandidateOfflineRawTransaction Model") {
			
			it("Can be initialized") {
				
				let nonce = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
				let data = RLP.encode([Data(hex: publicKey.stripMinterHexPrefix())])
				
				let model = SetCandidateOfflineRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, publicKey: publicKey)
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.type).to(equal(RawTransactionType.setCandidateOffline.BigUIntValue()))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"

				let data = RLP.encode([Data(hex: publicKey.stripMinterHexPrefix())])

				let model = SetCandidateOnlineRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, publicKey: publicKey)
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.data).to(equal(data))
				expect(model.type).to(equal(RawTransactionType.setCandidateOnline.BigUIntValue()))
			}
			
			it("It's data can be initialize") {
				
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
				
				let model = SetCandidateOfflineRawTransactionData(publicKey: publicKey)
				expect(model).toNot(beNil())
				expect(model.publicKey).to(equal(publicKey))
			}
			
			it("It's data can be initialize") {
				
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
				
				let model = SetCandidateOnlineRawTransactionData(publicKey: publicKey)
				expect(model).toNot(beNil())
				expect(model.publicKey).to(equal(publicKey))
			}
			
			it("It's data can be encoded/decoded") {
				
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
				
				let model = SetCandidateOfflineRawTransactionData(publicKey: publicKey)
				
				let encoded = try? JSONEncoder().encode(model)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SetCandidateOfflineRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				expect(decoded?.publicKey).to(equal(publicKey))
			}
			
			it("It's data can be encoded/decoded") {
				
				let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
				
				let model = SetCandidateOnlineRawTransactionData(publicKey: publicKey)
				
				let encoded = try? JSONEncoder().encode(model)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(SetCandidateOnlineRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				expect(decoded?.publicKey).to(equal(publicKey))
			}
		}
	}
}
