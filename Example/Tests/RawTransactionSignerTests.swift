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
import BigInt

class RawTransactionSignerSpec: QuickSpec {
	
	let privateKey = "5fa3a8b186f6cc2d748ee2d8c0eb7a905a7b73de0f2c34c5e7857c3b46f187da"
	let address = "Mx7633980c000139dd3bd24a3f54e06474fa941e16"
	
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
		
//		describe("RawTransactionSigner can sign") {
//
//			let validSign = "f88e01018a4d4e540000000000000001aae98a4d4e540000000000000094376615b9a3187747dc7c32e51723515ee62e37dc880de0b6b3a76400008b637573746f6d20746578748001b845f8431ba0dfd42ab59e68e6494d4e29f12520e7cd5a90c6d11b25599e868c2aac52440028a069f5f4085e1fe20b3e04701377a6d0320bb21f3162819ae3311318432aa332ea"
//
//			let params = SendCoinRawTransactionData(to: "Mx376615B9A3187747dC7c32e51723515Ee62e37Dc", value: BigUInt(1000000000000000000), coin: "MNT")
//			let payload = "custom text".data(using: .utf8)
//
//			let coin = "MNT".data(using: .utf8)?.setLengthRight(10)
//			let sendTx = SendCoinRawTransaction(nonce: BigUInt(1), gasCoin: coin!, to: "Mx376615B9A3187747dC7c32e51723515Ee62e37Dc", value: BigUInt(1000000000000000000), coin: "MNT")
//			sendTx.payload = payload!
//
//			let sig = RawTransactionSigner.sign(sendTx.encode(forSignature: true)!, privateKey: Data(hex: privateKey))
//
//			expect((sig.r! + sig.s! + sig.v!).toHexString()).to(equal(validSign))
//		}
		
	}
	
}
