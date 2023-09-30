//
//  DeeplinkManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 15.03.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import BigInt
import Foundation
@testable import MinterCore
import Nimble
import Quick

class DeeplinkManagerTestsSpec: BaseQuickSpec {
    override func spec() {
        super.spec()

        describe("Deeplink Manager") {
            it("Can make deeplink out of tx") {
                let transaction = SendCoinRawTransaction(nonce: BigUInt(0),
                                                         gasCoin: "BIP",
                                                         to: "Mx228e5a68b847d169da439ec15f727f08233a7ca6",
                                                         value: BigUInt(1),
                                                         coin: "BIP")
                let manager = DeepLinkManager(transaction: transaction)
                manager.encode()
                let correctDeeplink = "https://bip.to/tx/8gGi4YpCSVAAAAAAAAAAlCKOWmi4R9Fp2kOewV9yfwgjOnymAYCAAYpCSVAAAAAAAAAA"
                expect(manager.encode()?.absoluteString).to(equal(correctDeeplink))
            }
        }
    }
}
