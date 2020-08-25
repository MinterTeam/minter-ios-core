//
//  DeeplinkManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 15.03.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import BigInt

class DeeplinkManagerTestsSpec: BaseQuickSpec {

  override func spec() {
    super.spec()

    describe("Deeplink Manager") {
      it("Can make deeplink out of tx") {
        let transaction = SendCoinRawTransaction(nonce: BigUInt(0),
                                                 gasCoinId: Coin.baseCoin().id!,
                                                 to: "Mx228e5a68b847d169da439ec15f727f08233a7ca6",
                                                 value: BigUInt(1),
                                                 coinId: Coin.baseCoin().id!)
        let manager = DeepLinkManager(transaction: transaction)
        manager.encode()
        let correctDeeplink = "https://bip.to/tx/8gGi4YpCSVAAAAAAAAAAlCKOWmi4R9Fp2kOewV9yfwgjOnymAYCAAYpCSVAAAAAAAAAA"
        expect(manager.encode()?.absoluteString).to(equal(correctDeeplink))
      }
    }
  }
}
