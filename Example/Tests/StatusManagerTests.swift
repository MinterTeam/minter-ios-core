//
//  StatusManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore


class StatusManagerTestsSpec : BaseQuickSpec {
	
	let http = NodeAPIClient()
	var manager: StatusManager?
	
	override func spec() {
		super.spec()
		
		describe("StatusManager") {
			it("StatusManager can be initialized") {
				let manager = StatusManager(httpClient: self.http)
				
				expect(manager).toNot(beNil())
			}
			
			it("StatusManager can get status") {
				self.manager = StatusManager(httpClient: self.http)
				
				expect(self.manager).toNot(beNil())
				
				waitUntil(timeout: 10.0) { done in
					self.manager?.status(with: { (res, error) in
						
						expect(error).to(beNil())
						expect(res).toNot(beNil())
						
						done()
					})
				}
			}
		}
	}
}
