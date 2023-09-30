//
//  AccountManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class AccountManagerTestsSpec : BaseQuickSpec {
	
	let http = NodeAPIClient()
	
	var account: AccountManager?
	
	override func spec() {
		super.spec()
		
		describe("AccountManagerTests") {
			it("AccountManager") {
				let http = NodeAPIClient()
				
				let account = AccountManager(httpClient: http)
				expect(account).toNot(beNil())
			}
			
			it("Can request balance") {
				self.account = AccountManager(httpClient: self.http)

				expect(self.account).toNot(beNil())

                waitUntil(timeout: .seconds(10)) { done in
					self.account?.address("Mx4af34c3ca4c663dfed9020edc3e732c1b202b16c", with: { (resp, err) in
						expect(err).to(beNil())
						expect(resp).toNot(beNil())
						done()
					})
				}
			}

			it("Can request for balance") {

				self.account = AccountManager(httpClient: self.http)

				expect(self.account).toNot(beNil())

				waitUntil(timeout: .seconds(10)) { done in
					self.account?.address("1111", with: { (resp, err) in
						expect(err).toNot(beNil())
						expect(resp).to(beNil())
						done()
					})
				}
			}
		}
	}
	
}
