//
//  DeclareCandidacyRawTransactionTests.swift
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


class DeclareCandidacyRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("DeclareCandidacyRawTransaction Model") {
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let data = "data".data(using: .utf8)
				
				let model = DeclareCandidacyRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, data: data!)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.gasCoinId).to(equal(gasCoin))
				expect(model.data).to(equal(data))
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let coin = Coin.baseCoin().id!
				let address = "Mx7633980c000139dd3bd24a3f54e06474fa941e16"
				let publicKey = "Mp91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let commission = BigUInt(1)
				let stake = BigUInt(2)

				let pub = Data(hex: publicKey.stripMinterHexPrefix())
				let adrs = Data(hex: address.stripMinterHexPrefix())
				let fields = [adrs, pub, commission, coin, stake] as [Any]
				let rlp = RLP.encode(fields)

				let model = DeclareCandidacyRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, address: address, publicKey: publicKey, commission: commission, coinId: coin, stake: stake)
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.gasCoinId).to(equal(gasCoin))
				expect(model.type).to(equal(RawTransactionType.declareCandidacy.BigUIntValue()))
				expect(model.data).to(equal(rlp))
			}
			
			it("It's data can be initialized") {
				let coin = Coin.baseCoin().id!
				let address = "Mx7633980c000139dd3bd24a3f54e06474fa941e16"
				let publicKey = "Mp91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let commission = BigUInt(1)
				let stake = BigUInt(2)

				let data = DeclareCandidacyRawTransactionData(address: address, publicKey: publicKey, commission: commission, coinId: coin, stake: stake)
				
				expect(data).toNot(beNil())
				expect(data.address).to(equal(address))
				expect(data.publicKey).to(equal(publicKey))
				expect(data.commission).to(equal(commission))
				expect(data.coinId).to(equal(coin))
				expect(data.stake).to(equal(stake))
			}
			
			it("It's data can be encoded/decoded") {
        let coinId = Coin.baseCoin().id!
				let address = "Mx7633980c000139dd3bd24a3f54e06474fa941e16"
				let publicKey = "Mp91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
				let commission = BigUInt(1)
				let stake = BigUInt(2)
				
				let data = DeclareCandidacyRawTransactionData(address: address, publicKey: publicKey, commission: commission, coinId: coinId, stake: stake)
				
				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(DeclareCandidacyRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(decoded?.address).to(equal(address))
				expect(decoded?.publicKey).to(equal(publicKey))
				expect(decoded?.commission).to(equal(commission))
				expect(decoded?.coinId).to(equal(coinId))
				expect(decoded?.stake).to(equal(stake))
			}
		}
	}
}
