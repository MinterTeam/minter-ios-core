//
//  CoinManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore

class CoinManagerTestsSpec : BaseQuickSpec {
	
	let http = NodeAPIClient()
	var manager: CoinManager?
	
	override func spec() {
		super.spec()
		
		describe("CoinManager") {
			it("CoinManager can be initialized") {
				let manager = CoinManager(httpClient: self.http)
				expect(manager).toNot(beNil())
			}
			
			it("CoinManager can get coin info") {
				self.manager = CoinManager(httpClient: self.http)
				expect(self.manager).toNot(beNil())
				
				waitUntil(timeout: .seconds(10)) { done in
					self.manager?.info(symbol: "KLIM", completion: { (coin, error) in

						expect(error).to(beNil())
						expect(coin).toNot(beNil())
						expect(coin?.reserveBalance).toNot(beNil())

						done()
					})
				}
			}
			
			it("CoinManager can't get info of incorrect coin") {
				self.manager = CoinManager(httpClient: self.http)
				expect(self.manager).toNot(beNil())
				
				waitUntil(timeout: .seconds(10)) { done in
					self.manager?.info(symbol: "BBB11", completion: { (coin, error) in
						
						expect(error).toNot(beNil())
						expect(coin).to(beNil())
						
						done()
					})
				}
			}
		}
	}
}
