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


class CoinManagerTestsSpec : QuickSpec {
	
	let http = APIClient()
	var manager: CoinManager?
	
	override func spec() {
		MinterCoreSDK.initialize(urlString: "https://minter-node-2.testnet.minter.network:8841/")
		
		describe("CoinManager") {
			it("CoinManager can be initialized") {
				let manager = CoinManager(httpClient: self.http)
				expect(manager).toNot(beNil())
			}
			
			it("CoinManager can get coin info") {
				self.manager = CoinManager(httpClient: self.http)
				expect(self.manager).toNot(beNil())
				
				waitUntil(timeout: 10.0) { done in
					self.manager?.info(symbol: "BLACKCOIN", completion: { (coin, error) in
						
						expect(error).to(beNil())
						expect(coin).toNot(beNil())
						
						done()
					})
				}
			}
			
			it("CoinManager can't get info of incorrect coin") {
				self.manager = CoinManager(httpClient: self.http)
				expect(self.manager).toNot(beNil())
				
				waitUntil(timeout: 10.0) { done in
					self.manager?.info(symbol: "§&^", completion: { (coin, error) in
						
						expect(error).toNot(beNil())
						expect(coin).to(beNil())
						
						done()
					})
				}
			}
			
			
		}
	}
}
