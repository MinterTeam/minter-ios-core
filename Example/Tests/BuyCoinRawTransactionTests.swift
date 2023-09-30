//
//  BuyCoinRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 11/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BigInt
import Foundation
@testable import MinterCore
import Nimble
import Quick

class BuyCoinRawTransactionTestsSpec: BaseQuickSpec {
    override func spec() {
        describe("Can be initialized") {
            let gasCoin = "gasCoin".data(using: .utf8)!
            let data = "data".data(using: .utf8)!
            let nonce = BigUInt(1)
            let tx = BuyCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, data: data)

            expect(tx).toNot(beNil())
            expect(tx.nonce).to(equal(nonce))
            expect(tx.gasCoin).to(equal(gasCoin))
            expect(tx.data).to(equal(data))
        }

        describe("Can be initialized") {
            let gasCoin = "gasCoin".data(using: .utf8)!
            let nonce = BigUInt(1)
            let coinFrom = "MNT"
            let coinTo = "BPM"
            let value = BigUInt(1)
            let maximumValue = BigUInt(0)
            let tx = BuyCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, value: value, maximumValueToSell: maximumValue)

            let data = BuyCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, maximumValueToSell: maximumValue).encode()!

            expect(tx).toNot(beNil())
            expect(tx.nonce).to(equal(nonce))
            expect(tx.gasCoin).to(equal(gasCoin))
            expect(tx.data).to(equal(data))
        }

        describe("Can be encoded/decoded") {
            let coinFrom = "MNT"
            let coinTo = "BPM"
            let value = BigUInt(1)
            let maximumValue = BigUInt(0)
            let data = BuyCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, maximumValueToSell: maximumValue)

            let encoded = try? JSONEncoder().encode(data)
            expect(encoded).toNot(beNil())

            let decoded = try? JSONDecoder().decode(BuyCoinRawTransactionData.self, from: encoded!)
            expect(decoded).toNot(beNil())

            expect(decoded?.coinFrom).to(equal(coinFrom))
            expect(decoded?.coinTo).to(equal(coinTo))
            expect(decoded?.value).to(equal(value))
            expect(decoded?.maximumValueToSell).to(equal(maximumValue))
        }
    }
}
