//
//  CreateCoinRawTransactionTests.swift
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

class CreateCoinRawTransactionTestsSpec: BaseQuickSpec {

	override func spec() {
		describe("CreateCoinRawTransaction Model") {
			it("Can be initialized") {
				let data = "data".data(using: .utf8)!
				let nonce = BigUInt(1)
				let model = CreateCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: Coin.baseCoin().id!, data: data)
				
				expect(model).toNot(beNil())
				expect(model.data).to(equal(data))
				expect(model.nonce).to(equal(nonce))
				expect(model.type).to(equal(RawTransactionType.createCoin.BigUIntValue()))
			}

			it("Can be initialized") {
				let nonce = BigUInt(1)
				let initialAmount = BigUInt(2)
				let initialReserve = BigUInt(3)
				let reserveRatio = UInt(4)
        let maxSupply = BigUInt(10000)
				
				let symbol = "MNT2"
				let name = "Minter two"
				let gasCoin = Coin.baseCoin().id!
				
				let model = CreateCoinRawTransaction(nonce: nonce, chainId: 2, gasCoinId: gasCoin, name: name, symbol: symbol, initialAmount: initialAmount, initialReserve: initialReserve, reserveRatio: reserveRatio, maxSupply: maxSupply)
				
				let coinData = symbol.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
				
				let fields = [name, coinData, initialAmount, initialReserve, reserveRatio, maxSupply] as [Any]
				
				expect(model).toNot(beNil())
				expect(model.nonce).to(equal(nonce))
				expect(model.type).to(equal(RawTransactionType.createCoin.BigUIntValue()))
				expect(model.data).to(equal(RLP.encode(fields)))
			}
			
			it("Can initialize it's data") {
				let name = "Name"
				let symbol = "SYMBOL"
				let amount = BigUInt(1)
				let reserve = BigUInt(2)
				let ratio = UInt(3)
				
				let data = CreateCoinRawTransactionData(name: name, symbol: symbol, initialAmount: amount, initialReserve: reserve, reserveRatio: ratio, maxSupply: BigUInt(10000))
				
				expect(data).toNot(beNil())
				expect(data.name).to(equal(name))
				expect(data.symbol).to(equal(symbol))
				expect(data.initialAmount).to(equal(amount))
				expect(data.initialReserve).to(equal(reserve))
				expect(data.reserveRatio).to(equal(ratio))
				
			}
			it("Can encode/dcode it's data") {
				let name = "Name"
				let symbol = "SYMBOL"
				let amount = BigUInt(1)
				let reserve = BigUInt(2)
				let ratio = UInt(3)

				let data = CreateCoinRawTransactionData(name: name, symbol: symbol, initialAmount: amount, initialReserve: reserve, reserveRatio: ratio, maxSupply: BigUInt(10000))

				let encoded = try? JSONEncoder().encode(data)
				expect(encoded).toNot(beNil())

				let decoded = try? JSONDecoder().decode(CreateCoinRawTransactionData.self, from: encoded!)
				expect(decoded).toNot(beNil())
				expect(decoded?.name).to(equal(name))
				expect(decoded?.symbol).to(equal(symbol))
				expect(decoded?.initialAmount).to(equal(amount))
				expect(decoded?.initialReserve).to(equal(reserve))
				expect(decoded?.reserveRatio).to(equal(ratio))
			}

		}
	}
}
