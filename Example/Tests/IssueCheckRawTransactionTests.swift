//
//  IssueCheckRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 17/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BigInt
import Foundation
@testable import MinterCore
import Nimble
import ObjectMapper
import Quick

class IssueCheckRawTransactionSpec: BaseQuickSpec {
    override func spec() {
        describe("IssueCheckRawTransaction Model") {
            it("Can be initialized") {
                let nonce = "1"
                let dueBlock = BigUInt(99)
                let coin = "MNT"
                let value = BigUInt(1)
                let phrase = "123"

                let issue = IssueCheckRawTransaction(nonce: nonce, dueBlock: dueBlock, coin: coin, value: value, gasCoin: coin, passPhrase: phrase)

                expect(issue).toNot(beNil())
                expect(issue.nonce).to(equal(nonce))
                expect(issue.dueBlock).to(equal(dueBlock))
                expect(issue.coin).to(equal(coin))
                expect(issue.gasCoin).to(equal(coin))
                expect(issue.value).to(equal(value))
                expect(issue.passPhrase).to(equal(phrase))
            }

            it("Can be encoded/decoded") {
                let nonce = "1"
                let dueBlock = BigUInt(99)
                let coin = "MNT"
                let value = BigUInt(1)
                let phrase = "123"
                let data = IssueCheckRawTransaction(nonce: nonce, dueBlock: dueBlock, coin: coin, value: value, gasCoin: coin, passPhrase: phrase)

                let encoded = try? JSONEncoder().encode(data)
                expect(encoded).toNot(beNil())

                let decoded = try? JSONDecoder().decode(IssueCheckRawTransaction.self, from: encoded!)
                expect(decoded).toNot(beNil())

                expect(decoded?.nonce).to(equal(nonce))
                expect(decoded?.dueBlock).to(equal(dueBlock))
                expect(decoded?.coin).to(equal(coin))
                expect(decoded?.value).to(equal(value))
                expect(decoded?.passPhrase).to(equal(phrase))
            }
        }
    }
}
