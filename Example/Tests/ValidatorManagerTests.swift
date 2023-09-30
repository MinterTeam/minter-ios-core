//
//  ValidatorManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore

class ValidatorManagerTestsSpec : BaseQuickSpec {

	let http = NodeAPIClient()
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

				waitUntil(timeout: .seconds(10)) { done in

					self.manager?.validators(height: 0, with: { (validators, error) in
						expect(validators).toNot(beNil())
						expect(error).to(beNil())
						done()
					})
				}
			}
		}
	}
}
