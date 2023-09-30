//
//  ManagerDefaultTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import MinterCore
import Nimble
import Quick

class ManagerDefaultTestsSpec: QuickSpec {
    override func spec() {
        describe("ManagerDefault") {
            it("Can initialize") {
                expect(AccountManager.default).toNot(beNil())
                expect(TransactionManager.default).toNot(beNil())
                expect(CoinManager.default).toNot(beNil())
                expect(StatusManager.default).toNot(beNil())
                expect(CandidateManager.default).toNot(beNil())
                expect(ValidatorManager.default).toNot(beNil())
            }
        }
    }
}
