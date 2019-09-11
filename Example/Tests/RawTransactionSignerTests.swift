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
import CryptoSwift

class RawTransactionSignerSpec: BaseQuickSpec {
	
	let privateKey = "07bc17abdcee8b971bb8723e36fe9d2523306d5ab2d683631693238e0f9df142"
	let address = "Mx31e61a05adbd13c6b625262704bc305bf7725026"
	
	override func spec() {
		super.spec()
		
		describe("RawTransactionSigner") {
			
			it("RawTransactionSigner can retreive Public Key") {
				
				//Mx33bd6a537e8ad987b234ea3098c992f158df7b0f
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				let correctPublicKey = "039f1a49aa7bb95c587486d671838466137243f27b808a9eac4726ef3a33d6771b"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else {
					fatalError()
				}
				
				let pub = RawTransactionSigner.publicKey(privateKey: key.raw, compressed: true)
				expect(pub?.toHexString()).to(equal(correctPublicKey))
			}
			
			it("RawTransactionSigner can retreive Address") {
				
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else {
					fatalError()
				}
				
				let publicKey = RawTransactionSigner.publicKey(privateKey: key.raw, compressed: false)!.dropFirst()
				
				let address = RawTransactionSigner.address(publicKey: publicKey)
				
				expect(address).to(equal("33bd6a537e8ad987b234ea3098c992f158df7b0f"))
			}
			
			it("RawTransactionSigner can retreive Address") {
				
				let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
				
				let seed = String.seedString(mnemonic)!
				let pk = PrivateKey(seed: Data(hex: seed))
				
				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else {
					fatalError()
				}
				
				let address = RawTransactionSigner.address(privateKey: key.raw.toHexString())
				
				expect(address).to(equal("33bd6a537e8ad987b234ea3098c992f158df7b0f"))
			}
		}
		
		describe("RawTransactionSigner can sign tx") {
			it("Should be equal to valid sign") {
				let validSign = "f8840102018a4d4e540000000000000001aae98a4d4e5400000000000000941b685a7c1e78726c48f619c497a07ed75fe00483880de0b6b3a7640000808001b845f8431ca01f36e51600baa1d89d2bee64def9ac5d88c518cdefe45e3de66a3cf9fe410de4a01bc2228dc419a97ded0efe6848de906fbe6c659092167ef0e7dcb8d15024123a"

				let nonce = BigUInt(1)
				let gasCoin = "MNT"
				let sendTx = SendCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, to: "Mx1b685a7c1e78726c48f619c497a07ed75fe00483", value: BigUInt("1000000000000000000")!, coin: "MNT")
				let sig = RawTransactionSigner.sign(rawTx: sendTx, privateKey: self.privateKey)

				expect(sig).to(equal(validSign))
			}
		}
		
		describe("RawTransactionSigner can sign check") {
			it ("Should equal to check") {
				let pk = "64e27afaab363f21eec05291084367f6f1297a7b280d69d672febecda94a09ea"
				let pass = "pass"
				
				let validSign = "Mcf89f01830f423f8a4d4e5400000000000000888ac7230489e80000b841ada7ad273bef8a1d22f3e314fdfad1e19b90b1fe8dc7eeb30bd1d391e89af8642af029c138c2e379b95d6bc71b26c531ea155d9435e156a3d113a14c912dfebf001ba0eb3d47f227c3da3b29e09234ad24c49296f177234f3c9700d780712a656c338ba05726e0ed31ab98c07869a99f22e84165fe4a777b0bac7bcf287532210cae1bba"
				
				let nonce = BigUInt(1)
				var check = IssueCheckRawTransaction(nonce: nonce, dueBlock: BigUInt(999999), coin: "MNT", value: BigUInt("10000000000000000000")!, passPhrase: pass)
				let signed = check.serialize(privateKey: pk, passphrase: pass)
				
				expect(signed).to(equal(validSign))
			}
		}
		
		describe("RawTransactionSigner Proof") {
			it("Can make a proof") {
				let proof = "7f8b6d3ed18d2fe131bbdc9f9bce3b96724ac354ce2cfb49b4ffc4bd71aabf580a8dfed407a34122e45d290941d855d744a62110fa1c11448078b13d3117bdfc01"
				let address = RawTransactionSigner.address(privateKey: "5a34ec45e683c5254f6ef11723b9fd859f14677e04e4a8bb7768409eff12f07d")!
				let pass = "123456"
				let prf = RawTransactionSigner.proof(address: address.stripMinterHexPrefix(), passphrase: pass)?.toHexString()
				expect(prf).to(equal(proof))
			}
		}
		
		describe("RawTransactionSigner can verify private key") {
			let data = Data(hex: privateKey)
			let sig = RawTransactionSigner.verify(privateKey: data)
			
			expect(sig).to(beTrue())
		}
		
		describe("RawTransactionSigner Seed") {
			it("Can generate seed") {
				
				let mnemonic = "speed clutch food anxiety also rain eager symptom autumn butter fortune strike"
				let correctSeed = "9677142b43cdc9514634584bf8643e8c6ad80ec5e38fe00cf54ed12b29a2eec9a12d836dc096d1736d9c08111f666454c1ebc6604e62a43333599e6820f7a2e8"
				let res = RawTransactionSigner.seed(from: mnemonic, passphrase: "", language: .english)				
				expect(res).to(equal(correctSeed))
			}
			
			it("RawTransactionSigner can get seed") {
				let mnemonic = "speed clutch food anxiety also rain eager symptom autumn butter fortune strike"
				let correctSeed = "9677142b43cdc9514634584bf8643e8c6ad80ec5e38fe00cf54ed12b29a2eec9a12d836dc096d1736d9c08111f666454c1ebc6604e62a43333599e6820f7a2e8"
				
				let seed = String.seedString(mnemonic)!
				expect(seed).to(equal(correctSeed))
			}
		}
	}
}
