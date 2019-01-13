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
	
	let http = APIClient()
	
	var account: AccountManager?
	
	
	override func spec() {
		super.spec()
		
		describe("AccountManagerTests") {
			it("AccountManager") {
				let http = APIClient()
				
				let account = AccountManager(httpClient: http)
				expect(account).toNot(beNil())
			}
			
			it("Can request for balance") {
				
				self.account = AccountManager(httpClient: self.http)
				
				expect(self.account).toNot(beNil())
				
				waitUntil(timeout: 10.0) { done in
					self.account?.address("Mx184ac726059e43643e67290666f7b3195093f870", with: { (resp, err) in
						expect(err).to(beNil())
						expect(resp).toNot(beNil())
						done()
					})
				}
			}
			
			it("Can request for balance") {
				MinterCoreSDK.initialize(urlString: "https://minter-node-2.testnet.minter.network:8841/")
				
				self.account = AccountManager(httpClient: self.http)
				
				expect(self.account).toNot(beNil())
				
				waitUntil(timeout: 10.0) { done in
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
