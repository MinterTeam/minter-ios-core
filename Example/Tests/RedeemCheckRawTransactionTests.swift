//
//  RedeemCheckRawTransactionTests.swift
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


class RedeemCheckRawTransactionSpec: QuickSpec {
	
	override func spec() {
		describe("RedeemCheckRawTransaction Model") {
			it("Can be initialized") {
				
				let check = "check".data(using: .utf8)
				let proof = "proof".data(using: .utf8)
				let tx = RedeemCheckRawTransaction(gasCoin: "MNT", rawCheck: check!, proof: proof!)
				
				let rlp = RLP.encode([check, proof])
				
				expect(tx?.data).to(equal(rlp))
			}
			
			it("Can be encoded/decoded") {
				
				let check = "check".data(using: .utf8)
				let proof = "proof".data(using: .utf8)
				let tx = RedeemCheckRawTransaction(gasCoin: "MNT", rawCheck: check!, proof: proof!)
				
				let encoded = try? JSONEncoder().encode(tx)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(RedeemCheckRawTransaction.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(tx).notTo(beNil())
				expect(tx?.type).to(equal(RawTransactionType.redeemCheck.BigUIntValue()))
			}
			
			it("Can be encoded/decoded") {
				
				let check = "check".data(using: .utf8)
				let proof = "proof".data(using: .utf8)
				let tx = RedeemCheckRawTransactionData(rawCheck: check!, proof: proof!)
				
				let encoded = try? JSONEncoder().encode(tx)
				
				let decoded = try? JSONDecoder().decode(RedeemCheckRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(tx).notTo(beNil())
			}
		}
	}
}
