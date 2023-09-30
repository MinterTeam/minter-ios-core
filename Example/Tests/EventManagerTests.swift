//
//  EventManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore

class EventManagerTestsSpec : BaseQuickSpec {
	
	let http = NodeAPIClient()
	var manager: EventManager = EventManager.default
	
	override func spec() {
		super.spec()
		
		describe("EventManager") {
			it("EventManager can be initialized") {
				waitUntil(timeout: .seconds(10)) { done in
					self.manager.events(height: "100") { events, error in
						
						expect(events).toNot(beNil())
						expect(error).to(beNil())
						
						done()
					}
				}
			}
		}
	}
}

