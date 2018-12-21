//
//  TransactionManagerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 20/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore


class TransactionManagerTestsSpec : QuickSpec {
	
	let http = APIClient()
	var manager: TransactionManager?
	
	override func spec() {
		MinterCoreSDK.initialize(urlString: "https://minter-node-2.testnet.minter.network:8841/")
		
		describe("TransactionManager") {
			it("TransactionManager can be initialized") {
				let manager = TransactionManager(httpClient: self.http)
				expect(manager).toNot(beNil())
			}
			
			//Transaction info
			
			it("TransactionManager can get transaction info") {
				
				self.manager = TransactionManager.default
				
				waitUntil(timeout: 10) { done in
					self.manager?.transaction(hash: "Mt7dd5c558b1c2691be28fabf6a6ed39553d171e9f212c06585fa914594ef5aa82", completion: { (transaction, error) in
						
						expect(error).to(beNil())
						expect(transaction).toNot(beNil())
						
						done()
					})
				}
			}
			
			it("TransactionManager can't get transaction info with invalid hash") {
				
				self.manager = TransactionManager.default
				
				waitUntil(timeout: 10) { done in
					self.manager?.transaction(hash: "00", completion: { (transaction, error) in
						
						expect(error).toNot(beNil())
						expect(transaction).to(beNil())
						
						done()
					})
				}
			}
			
			it("TransactionManager can't get transaction info with invalid hash") {
				
				self.manager = TransactionManager.default
				
				waitUntil(timeout: 10) { done in
					self.manager?.transaction(hash: "Mt11d5c558b1c2691be28fabf6a6ed39553d171e9f212c06585f77665544332211", completion: { (transaction, error) in
						
						expect(error).toNot(beNil())
						expect(transaction).to(beNil())
						
						done()
					})
				}
			}
			
			//Estimates
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinBuy(from: "MNT", to: "BLACKCOIN", amount: Decimal(string: "10000000000")!, completion: { (willPay, commission, error) in
						
						expect(error).to(beNil())
						expect(willPay).toNot(beNil())
						expect(commission).toNot(beNil())
						done()
					})
				}
			}
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinBuy(from: "MNT", to: "BLACKCOIN", amount: Decimal(string: "-1")!, completion: { (willPay, commission, error) in
						
						expect(error).toNot(beNil())
						expect(willPay).to(beNil())
						expect(commission).to(beNil())
						done()
					})
				}
			}
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinBuy(from: "MNT", to: "111", amount: Decimal(string: "1")!, completion: { (willPay, commission, error) in
						
						expect(error).toNot(beNil())
						expect(willPay).to(beNil())
						expect(commission).to(beNil())
						done()
					})
				}
			}
			
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinSell(from: "MNT", to: "BLACKCOIN", amount: Decimal(string: "10000000000")!, completion: { (willPay, commission, error) in
						
						expect(error).to(beNil())
						expect(willPay).toNot(beNil())
						expect(commission).toNot(beNil())
						done()
					})
				}
			}
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinSell(from: "MNT", to: "BLACKCOIN", amount: Decimal(string: "-1")!, completion: { (willPay, commission, error) in
						
						expect(error).toNot(beNil())
						expect(willPay).to(beNil())
						expect(commission).to(beNil())
						done()
					})
				}
			}
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinSell(from: "MNT", to: "111", amount: Decimal(string: "1")!, completion: { (willPay, commission, error) in
						
						expect(error).toNot(beNil())
						expect(willPay).to(beNil())
						expect(commission).to(beNil())
						done()
					})
				}
			}
			
			it("Can estimate comission") {
				
				let tx = "f88313018a424c41434b434f494e0001aae98a424c41434b434f494e0094228e5a68b847d169da439ec15f727f08233a7ca6883ed6df8a5bc9f6f1808001b845f8431ca02814f29ccc1c1438532d286ce285f3897939281c36da7785ab99f76e2e5f8f91a074acc3624f466302addf4b734eeac4f977179cf1d93f7351cf74c2acda5732f1"
				
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCommission(for: tx, completion: { (comission, error) in
						expect(comission).toNot(beNil())
						expect(error).to(beNil())
						
						done()
					})
					
				}
			}
			
			it("Can't estimate comission") {
				
				let tx = "111f88313018a424c41434b434f494e0001aae98a424c41434b434f494e0094228e5a68b847d169da439ec15f727f08233a7ca6883ed6df8a5bc9f6f1808001b845f8431ca02814f29ccc1c1438532d286ce285f3897939281c36da7785ab99f76e2e5f8f91a074acc3624f466302addf4b734eeac4f977179cf1d93f7351cf74c2acda5732f1"
				
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCommission(for: tx, completion: { (comission, error) in
						expect(comission).to(beNil())
						expect(error).toNot(beNil())
						
						done()
					})
					
				}
			}
			
			
		}
	}
}
