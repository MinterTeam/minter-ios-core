//
//  RawTransactionSignerTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 31/08/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class RawTransactionSignerSpec: QuickSpec {
	
	override func spec() {
		describe("RawTransactionSigner") {
			
			it("RawTransactionSigner can retreive Public Key") {
				
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				
				let key = pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0)
				
				let pub = RawTransactionSigner.publicKey(privateKey: key.raw, compressed: true)
				
				expect(pub?.toHexString()).to(equal("039f1a49aa7bb95c587486d671838466137243f27b808a9eac4726ef3a33d6771b"))
				
			}
			
			it("RawTransactionSigner can retreive Address") {
				
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				let key = pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0)
				
				let publicKey = RawTransactionSigner.publicKey(privateKey: key.raw, compressed: false)!.dropFirst()
				
				let address = RawTransactionSigner.address(publicKey: publicKey)
				
				expect(address).to(equal("33bd6a537e8ad987b234ea3098c992f158df7b0f"))
			}
			
			it("RawTransactionSigner can retreive Address") {
				
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				let key = pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0)
				
				let address = RawTransactionSigner.address(privateKey: key.raw.toHexString())
				
				expect(address).to(equal("33bd6a537e8ad987b234ea3098c992f158df7b0f"))
			}
			
		}
	}
	
}
