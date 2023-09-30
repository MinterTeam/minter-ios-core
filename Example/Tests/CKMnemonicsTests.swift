//
//  CKMnemonics.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 16/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import GoldenKeystore
@testable import MinterCore
import Nimble
import Quick

class CKMnemonicsTestsSpec: QuickSpec {
    override func spec() {
        describe("CKMnemonicsTestsSpec") {
            it("CKMnemonicsTestsSpec tests") {
                let incorrectOne = "forget token answer whip crowd faith inquiry size secret reopen cabbage also"
                expect(GoldenKeystore.mnemonicIsValid(incorrectOne)).to(beFalse())

                for _ in 0 ... 1000 {
                    if let mnemonic = String.generateMnemonicString() {
                        let mnemonicTest = GoldenKeystore.mnemonicIsValid(mnemonic)
                        print(mnemonic)
                        print(mnemonicTest)
                        expect(mnemonicTest).to(beTrue())
                    } else {
                        fatalError("What?")
                    }
                }
            }
        }
    }
}
