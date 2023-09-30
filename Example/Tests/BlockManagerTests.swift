//
//  BlocksManager.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
@testable import MinterCore
import Nimble
import Quick

class BlocksManagerTestsSpec: BaseQuickSpec {
    let http = APIClient()
    var manager: BlockManager = .default

    override func spec() {
        super.spec()

        describe("BlocksManager") {
            it("BlocksManager can be initialized") {
                //				waitUntil(timeout: 10.0) { done in
                //					self.manager.blocks(height: "1") { blocks, error in
//
                //						expect(blocks).toNot(beNil())
                //						expect(error).to(beNil())
//
                //						done()
                //					}
                //				}
            }
        }
    }
}
