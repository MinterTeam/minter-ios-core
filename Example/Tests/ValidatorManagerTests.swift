//
//  ValidatorManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
@testable import MinterCore
import Nimble
import Quick

class ValidatorManagerTestsSpec: BaseQuickSpec {
    let http = APIClient()
    var manager: ValidatorManager?

    override func spec() {
        super.spec()

        describe("ValidatorManager") {
            it("ValidatorManager can be initialized") {
                let manager = ValidatorManager(httpClient: self.http)
                expect(manager).toNot(beNil())
            }

            it("ValidatorManager can be initialized") {
                self.manager = ValidatorManager(httpClient: self.http)

                //				waitUntil(timeout: 30.0) { done in
//
                //					self.manager?.validators(height: 1, with: { (validators, error) in
                //						expect(validators).toNot(beNil())
                //						expect(error).to(beNil())
                //						done()
                //					})
//
                //				}
            }
        }
    }
}
