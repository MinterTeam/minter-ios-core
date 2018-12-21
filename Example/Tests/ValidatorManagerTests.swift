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


class ValidatorManagerTestsSpec : QuickSpec {
	
	let http = APIClient()
	var manager: ValidatorManager?
	
	override func spec() {
		MinterCoreSDK.initialize(urlString: "https://minter-node-2.testnet.minter.network:8841/")
		
		describe("ValidatorManager") {
			it("ValidatorManager can be initialized") {
				let manager = ValidatorManager(httpClient: self.http)
				expect(manager).toNot(beNil())
			}
			
			it("ValidatorManager can be initialized") {
				self.manager = ValidatorManager(httpClient: self.http)
				
				waitUntil(timeout: 10.0) { done in
					
					self.manager?.validators(with: { (validators, error) in
						expect(validators).toNot(beNil())
						expect(error).to(beNil())
						done()
					})
					
				}
			}
			
		}
		
	}
}
