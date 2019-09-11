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
import BigInt
@testable import MinterCore


class TransactionManagerTestsSpec : BaseQuickSpec {
	
	let http = APIClient()
	var manager: TransactionManager? = TransactionManager.default
	
	override func spec() {
		super.spec()
		
		describe("TransactionManager") {
			it("TransactionManager can be initialized") {
				let manager = TransactionManager(httpClient: self.http)
				expect(manager).toNot(beNil())
			}
			
			//Transaction info
			it("TransactionManager can get transaction info") {
				
				self.manager = TransactionManager.default
				
				waitUntil(timeout: 10) { done in
					self.manager?.transaction(hash: "Mt9c9e310e5a6ed848eba71f7b3c7c51b291c4d5f63858749051290125a14e6b64", completion: { (transaction, error) in
						
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
			
			it("TransactionManager can get unconfirmed transactions") {
				
				self.manager = TransactionManager.default
				
				waitUntil(timeout: 10) { done in
					self.manager?.unconfirmedTransaction(limit: "20000000000000", completion: { (transactions, error) in
						
						expect(error).to(beNil())
						expect(transactions).toNot(beNil())
						
						done()
					})
				}
			}
			
			//Estimates
			
			it("TransactionManager can get estimate") {
				self.manager = TransactionManager.default
				waitUntil(timeout: 10) { done in
					self.manager?.estimateCoinBuy(from: "MNT", to: "VALIDATOR", amount: Decimal(string: "10000000000")!, completion: { (willPay, commission, error) in
						
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
					self.manager?.estimateCoinBuy(from: "MNT", to: "VALIDATOR", amount: Decimal(string: "-1")!, completion: { (willPay, commission, error) in
						
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
					self.manager?.estimateCoinSell(from: "MNT", to: "VALIDATOR", amount: Decimal(string: "10000000000")!, completion: { (willPay, commission, error) in
						
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
					self.manager?.estimateCoinSell(from: "MNT", to: "VALIDATOR", amount: Decimal(string: "-1")!, completion: { (willPay, commission, error) in
						
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
				
				let sendTX = SendCoinRawTransaction(nonce: BigUInt(1), chainId: 2, gasCoin: "MNT", to: "Mx5974a5121cf6bd54118fad788f7d1ae47b33e198", value: BigUInt(1), coin: "MNT")
				let tx = RawTransactionSigner.sign(rawTx: sendTX, privateKey: "8da1c947b489399a5b07b6bd3d9bb41f7647bb01a28303431b6993a8092f0bed")!
				
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

//			it("Can create multisig transaction") {
//
//				let correctTx = "f84701018a4d4e54000000000000000cb0ef01c20101ea9433bd6a537e8ad987b234ea3098c992f158df7b0f9433bd6a537e8ad987b234ea3098c992f158df7b0f80800184c3018080"
//
//				let data = CreateMultisigAddressRawTransactionData(threshold: BigUInt(1), weights: [BigUInt(1), BigUInt(1)], addresses: ["Mx33bd6a537e8ad987b234ea3098c992f158df7b0f", "Mx33bd6a537e8ad987b234ea3098c992f158df7b0f"])
//				let encoded = data.encode()
//
//				expect(encoded).toNot(beNil())
//
//				let tx = CreateMultisigAddressRawTransaction(nonce: BigUInt(1), type: RawTransactionType.createMultisigAddress.BigUIntValue(), gasCoin: "MNT", data: encoded!)
//
//				expect(tx).toNot(beNil())
//				expect(tx.encode()?.toHexString()).to(equal(correctTx))
//			}

			it("Can create custom coin") {
				let mnemonic = "dial script notice debris supreme game crisp taste place web gesture execute"
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else { return }
				
				let newCoin = CreateCoinRawTransaction(nonce: BigUInt(1), chainId: 2, gasCoin: "MNT", name: "TESTCOIN", symbol: "TESTCOIN", initialAmount: BigUInt(1), initialReserve: BigUInt(100), reserveRatio: BigUInt(15))

				let signed = RawTransactionSigner.sign(rawTx: newCoin, privateKey: key.raw.toHexString())
				
				self.manager?.send(tx: "Mt" + signed!, completion: { (res1, res2, error) in
					
				})
			}
		}
	}
}
