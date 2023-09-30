//
//  EventManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
@testable import MinterCore
import Nimble
import Quick

class EventManagerTestsSpec: BaseQuickSpec {
    let http = APIClient()
    var manager: EventManager = .default

    override func spec() {
        super.spec()

        describe("EventManager") {
            it("EventManager can be initialized") {
                //				waitUntil(timeout: 10.0) { done in
                //					self.manager.events(height: "100") { events, error in
//
                //						expect(events).toNot(beNil())
                //						expect(error).to(beNil())
//
                //						done()
                //					}
                //				}
            }
        }
    }
}
