//
//  CandidateManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 19/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore


class CandidateManagerTestsSpec : QuickSpec {
	
	let http = APIClient()
	var manager: CandidateManager?
	
	override func spec() {
		MinterCoreSDK.initialize(urlString: "https://minter-node-2.testnet.minter.network:8841/")
		
		describe("CandidateManager") {
			it("CandidateManager can be initialized") {
				let manager = CandidateManager(httpClient: self.http)
				
				expect(manager).toNot(beNil())
			}
			
			it("CandidateManager can request candiadte data") {
				self.manager = CandidateManager(httpClient: self.http)
				
				waitUntil(timeout: 10.0) { done in
					self.manager?.candidate(publicKey: "Mpeebf92355b8e6717bc200d5637de8d8b2d3dec5e81a4555ef0a77482108a3c9b", completion: { (response, error) in
						
						expect(error).to(beNil())
						expect(response).toNot(beNil())
						
						done()
					})
				}
			}
			
			it("CandidateManager can request incorrect candiadte") {
				self.manager = CandidateManager(httpClient: self.http)
				
				waitUntil(timeout: 10.0) { done in
					self.manager?.candidate(publicKey: "112", completion: { (response, error) in
						
						expect(error).toNot(beNil())
						expect(response).to(beNil())
						
						done()
					})
				}
			}
			
		}
	}
}
