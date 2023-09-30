//
//  MultisigRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 05.03.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import BigInt
import Foundation
@testable import MinterCore
import Nimble
import ObjectMapper
import Quick

class MultisigRawTransactionTestsSpec: BaseQuickSpec {
    override func spec() {
        describe("MultisigRawTransaction Model") {
            it("Can initialize it's data") {
                let correctSigned = "f8a30102018a4d4e54000000000000000cb848f84607c3010305f83f94ee81347211c72524338f9680072af9074433314394ee81347211c72524338f9680072af9074433314594ee81347211c72524338f9680072af90744333144808001b845f8431ca094eb41d39e6782f5539615cc66da7073d4283893f0b3ee2b2f36aee1eaeb7c57a037f90ffdb45eb9b6f4cf301b48e73a6a81df8182e605b656a52057537d264ab4"
                let tx = CreateMultisigAddressRawTransaction(nonce: BigUInt(1),
                                                             chainId: 2,
                                                             gasCoin: "MNT",
                                                             threshold: BigUInt(7),
                                                             weights: [BigUInt(1), BigUInt(3), BigUInt(5)],
                                                             addresses: ["Mxee81347211c72524338f9680072af90744333143",
                                                                         "Mxee81347211c72524338f9680072af90744333145",
                                                                         "Mxee81347211c72524338f9680072af90744333144"])
                let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: "bc3503cae8c8561df5eadc4a9eda21d32c252a6c94cfae55b5310bf6085c8582")
                expect(signed).to(equal(correctSigned))
            }

            it("Can be signed") {
                let validTx = "0xf901270102018a4d4e540000000000000001aae98a4d4e540000000000000094d82558ea00eb81d35f2654953598f5d51737d31d880de0b6b3a7640000808002b8e8f8e694db4f4b6942cb927e8d7e3a1f602d0f1fb43b5bd2f8cff8431ca0a116e33d2fea86a213577fc9dae16a7e4cadb375499f378b33cddd1d4113b6c1a021ee1e9eb61bbd24233a0967e1c745ab23001cf8816bb217d01ed4595c6cb2cdf8431ca0f7f9c7a6734ab2db210356161f2d012aa9936ee506d88d8d0cba15ad6c84f8a7a04b71b87cbbe7905942de839211daa984325a15bdeca6eea75e5d0f28f9aaeef8f8431ba0d8c640d7605034eefc8870a6a3d1c22e2f589a9319288342632b1c4e6ce35128a055fe3f93f31044033fe7b07963d547ac50bccaac38a057ce61665374c72fb454"
                let address = "Mxdb4f4b6942cb927e8d7e3a1f602d0f1fb43b5bd2"
                let pks = [
                    "b354c3d1d456d5a1ddd65ca05fd710117701ec69d82dac1858986049a0385af9",
                    "38b7dfb77426247aed6081f769ed8f62aaec2ee2b38336110ac4f7484478dccb",
                    "94c0915734f92dd66acfdc48f82b1d0b208efd544fe763386160ec30c968b4af",
                ]

                let sendTx = SendCoinRawTransaction(nonce: BigUInt(1),
                                                    chainId: 2,
                                                    gasCoin: "MNT",
                                                    to: "Mxd82558ea00eb81d35f2654953598f5d51737d31d",
                                                    value: BigUInt("1000000000000000000")!,
                                                    coin: "MNT")
                let signed = RawTransactionSigner.sign(rawTx: sendTx,
                                                       address: address,
                                                       privateKeys: pks)
                expect(signed).to(equal(validTx))
            }
        }
    }
}
