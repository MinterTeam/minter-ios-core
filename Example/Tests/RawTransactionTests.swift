//
//  RawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 12/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper
import BigInt


class RawTransactionSpec: BaseQuickSpec {

	override func spec() {
		describe("RawTransaction Model Init") {
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let gasPrice = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let type = RawTransactionType.sendCoin.BigUIntValue()
				let payload = "payload".data(using: .utf8)!
				let serviceData = "serviceData".data(using: .utf8)!
				
				let rawTx = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type, payload: payload, serviceData: serviceData)
				
				expect(rawTx).notTo(beNil())
				expect(rawTx.nonce).to(equal(nonce))
				expect(rawTx.gasPrice).to(equal(gasPrice))
				expect(rawTx.gasCoinId).to(equal(gasCoin))
				expect(rawTx.type).to(equal(type))
				expect(rawTx.payload).to(equal(payload))
				expect(rawTx.serviceData).to(equal(serviceData))
				
			}
			
			it("Can be initialized") {
				let nonce = BigUInt(1)
				let gasPrice = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let type = RawTransactionType.sendCoin.BigUIntValue()
				let data = "data".data(using: .utf8)!
				let payload = "payload".data(using: .utf8)!
				let signatureType = BigUInt(1)
				let serviceData = "serviceData".data(using: .utf8)!
				
				let v = Data()
				let r = Data()
				let s = Data()
				
				let signatureData = RawTransaction.SignatureData(v: v, r: r, s: s)
				
				
				let rawTx = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type, data: data, payload: payload, serviceData: serviceData, signatureType: signatureType, signatureData: signatureData)
				
				expect(rawTx).notTo(beNil())
				expect(rawTx.nonce).to(equal(nonce))
				expect(rawTx.gasPrice).to(equal(gasPrice))
				expect(rawTx.gasCoinId).to(equal(gasCoin))
				expect(rawTx.type).to(equal(type))
				expect(rawTx.data).to(equal(data))
				expect(rawTx.payload).to(equal(payload))
				expect(rawTx.serviceData).to(equal(serviceData))
				expect(rawTx.signatureType).to(equal(signatureType))
				expect(rawTx.signatureData.v).to(equal(v))
				expect(rawTx.signatureData.r).to(equal(r))
				expect(rawTx.signatureData.s).to(equal(s))
				
			}
			
			it("Can be initialized with different types") {
				let nonce = BigUInt(1)
				let gasPrice = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let type = RawTransactionType.sellCoin.BigUIntValue()
				let payload = "payload".data(using: .utf8)!
				let serviceData = "serviceData".data(using: .utf8)!
				
				let rawTx = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type, payload: payload, serviceData: serviceData)
				expect(rawTx).notTo(beNil())
				expect(rawTx.type).to(equal(type))
				
				let type1 = RawTransactionType.sellAllCoins.BigUIntValue()
				let rawTx1 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type1, payload: payload, serviceData: serviceData)
				expect(rawTx1).notTo(beNil())
				expect(rawTx1.type).to(equal(type1))
				
				let type2 = RawTransactionType.buyCoin.BigUIntValue()
				let rawTx2 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type2, payload: payload, serviceData: serviceData)
				expect(rawTx2).notTo(beNil())
				expect(rawTx2.type).to(equal(type2))
				
				let type3 = RawTransactionType.createCoin.BigUIntValue()
				let rawTx3 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type3, payload: payload, serviceData: serviceData)
				expect(rawTx3).notTo(beNil())
				expect(rawTx3.type).to(equal(type3))
				
				let type4 = RawTransactionType.declareCandidacy.BigUIntValue()
				let rawTx4 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type4, payload: payload, serviceData: serviceData)
				expect(rawTx4).notTo(beNil())
				expect(rawTx4.type).to(equal(type4))
				
				let type5 = RawTransactionType.delegate.BigUIntValue()
				let rawTx5 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type5, payload: payload, serviceData: serviceData)
				expect(rawTx5).notTo(beNil())
				expect(rawTx5.type).to(equal(type5))
				
				let type6 = RawTransactionType.unbond.BigUIntValue()
				let rawTx6 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type6, payload: payload, serviceData: serviceData)
				expect(rawTx6).notTo(beNil())
				expect(rawTx6.type).to(equal(type6))
				
				let type7 = RawTransactionType.redeemCheck.BigUIntValue()
				let rawTx7 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type7, payload: payload, serviceData: serviceData)
				expect(rawTx7).notTo(beNil())
				expect(rawTx7.type).to(equal(type7))
				
				let type8 = RawTransactionType.setCandidateOnline.BigUIntValue()
				let rawTx8 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type8, payload: payload, serviceData: serviceData)
				expect(rawTx8).notTo(beNil())
				expect(rawTx8.type).to(equal(type8))
				
				let type9 = RawTransactionType.setCandidateOffline.BigUIntValue()
				let rawTx9 = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type9, payload: payload, serviceData: serviceData)
				expect(rawTx9).notTo(beNil())
				expect(rawTx9.type).to(equal(type9))
			}
		}
		
		describe("RawTransaction SignatureData encode") {
			it("Can be encoded") {
				
				let v = Data()
				let r = Data()
				let s = Data()
				
				let signatureData = RawTransaction.SignatureData(v: v, r: r, s: s)
				expect(signatureData).notTo(beNil())
			}
			
			it("Can be encoded/decoded") {
				let nonce = BigUInt(1)
				let gasPrice = BigUInt(1)
				let gasCoin = Coin.baseCoin().id!
				let type = RawTransactionType.sellCoin.BigUIntValue()
				let payload = "payload".data(using: .utf8)!
				let serviceData = "serviceData".data(using: .utf8)!
				
				let rawTx = RawTransaction(nonce: nonce, gasPrice: gasPrice, gasCoinId: gasCoin, type: type, payload: payload, serviceData: serviceData)
				
				let encoded = try? JSONEncoder().encode(rawTx)
				expect(encoded).toNot(beNil())
				
				let decoded = try? JSONDecoder().decode(RawTransaction.self, from: encoded!)
				expect(decoded).toNot(beNil())
				
				expect(rawTx).notTo(beNil())
				expect(rawTx.type).to(equal(type))
			}
			
		}
		
	}
}
