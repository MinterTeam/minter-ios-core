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

class CandidateManagerTestsSpec: BaseQuickSpec {

	let http = NodeAPIClient()
	var manager: CandidateManager?

	override func spec() {
		super.spec()

		describe("CandidateManager") {
			it("CandidateManager can be initialized") {
				let manager = CandidateManager(httpClient: self.http)

				expect(manager).toNot(beNil())
			}

			it("CandidateManager can request candiadte data") {
				self.manager = CandidateManager(httpClient: self.http)

				waitUntil(timeout: .seconds(10)) { done in
					self.manager?.candidate(publicKey: "Mp0208f8a2bd535f65ecbe4b057b3b3c5fbfef6003b0713dc37b697b1d19153fe8", completion: { (response, error) in

						expect(error).to(beNil())
						expect(response).toNot(beNil())

						done()
					})
				}
			}

			it("CandidateManager can request incorrect candiadte") {
				self.manager = CandidateManager(httpClient: self.http)
				
				waitUntil(timeout: .seconds(10)) { done in
					self.manager?.candidate(publicKey: "112", completion: { (response, error) in
						
						expect(error).toNot(beNil())
						expect(response).to(beNil())
						
						done()
					})
				}
			}
			
			it("CandidateManager can retreive candidates") {
				self.manager = CandidateManager(httpClient: self.http)

				waitUntil(timeout: .seconds(10)) { done in
					self.manager?.candidates(includeStakes: false, completion: { (response, error) in

						expect(error).to(beNil())
						expect(response).toNot(beNil())

						done()
					})
				}
			}
			
		}
	}
}
