//
//  PrivateKeyTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 05/09/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper

class PrivateKeySpec: BaseQuickSpec {

	override func spec() {
		describe("Can be initialized") {
			it("Can be initialized with seed Data") {
				let correctSeed = "e4d6956689cfba26aab4156e5f4600f5f386cdd56ea57f1bfdb40f33048d4d463989c170738ae582f07227af9fd707b40cc7d7d6fd24d14a4ee1e0f45928940d"
				let data = Data(hex: "646beb039851b4af56d1e19f6953390c02c0c67f11ef6d150b03513ab5e71646")
				let chainCode = Data(hex: "ba034e6da3199ebd18ed7616a641be0b3b0e0760c7e8b0ebf16318c57e312461")

				let pk = PrivateKey(seed: correctSeed.data(using: .utf8)!)
				expect(pk).toNot(beNil())
				expect(pk.raw).to(equal(data))
				expect(pk.chainCode).to(equal(chainCode))
			}

			it("Can be initialize with raw data") {
				let data = Data(hex: "646beb039851b4af56d1e19f6953390c02c0c67f11ef6d150b03513ab5e71646")
				let chainCode = Data(hex: "ba034e6da3199ebd18ed7616a641be0b3b0e0760c7e8b0ebf16318c57e312461")
				
				let pk = PrivateKey(privateKey: data, chainCode: chainCode)
				expect(pk).notTo(beNil())
				expect(pk.raw).to(equal(data))
				expect(pk.chainCode).to(equal(chainCode))
			}

			it("Can be initialize with raw data") {
				let data = Data(hex: "646beb039851b4af56d1e19f6953390c02c0c67f11ef6d150b03513ab5e71646")
				let chainCode = Data(hex: "ba034e6da3199ebd18ed7616a641be0b3b0e0760c7e8b0ebf16318c57e312461")
				
				let pk = PrivateKey(privateKey: data, chainCode: chainCode, depth: 0, fingerprint: 0, childIndex: 0)
				expect(pk).notTo(beNil())
				expect(pk.raw).to(equal(data))
				expect(pk.chainCode).to(equal(chainCode))
				expect(pk.depth).to(equal(0))
				expect(pk.fingerprint).to(equal(0))
				expect(pk.childIndex).to(equal(0))
			}
		}

		describe("Can get extended key") {
			it("Can be transformed to extended key") {
				let correctExtendedKey = "xprv9s21ZrQH143K2g7HhNwboEpr76sra2rvUrDRJcYoDXasFmBNs2qyr15ZJJkWrPvegVdKWbT1xxoy7LjTVecPJrfK4xzB1c85PbkUjmtTMR9"
				let correctSeed = "8b2868665a92d1043b55f9ccbfb4b2d2fcfd7e2111c16b0d51cef0983f95a9438f643cef3cc41277331f3da0e957110be1bc6a80771613859ea2999bbeea2876"

				let pk = PrivateKey(seed: Data(hex: correctSeed))
				let extended = pk.extended()
				expect(extended).to(equal(correctExtendedKey))
			}
		}

		it("Can retreive public key") {
			let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"

			let seed = String.seedString(mnemonic)!
			let pk = PrivateKey(seed: Data(hex: seed))

			guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else {
				fatalError()
			}
			let publicKey = key.publicKey.toHexString()
			expect(publicKey).to(equal("039f1a49aa7bb95c587486d671838466137243f27b808a9eac4726ef3a33d6771b"))
		}

		describe("Can be derived") {
			it("Can be derived with path 44/60/0/0/0") {
				let correctSeed = "8b2868665a92d1043b55f9ccbfb4b2d2fcfd7e2111c16b0d51cef0983f95a9438f643cef3cc41277331f3da0e957110be1bc6a80771613859ea2999bbeea2876"
				let pk = PrivateKey(seed: Data(hex: correctSeed))

				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0) else {
					fatalError()
				}
				expect(key.raw.toHexString()).to(equal("6868abf30e1938fdc0a5eb5c6928360fe75802f0b974f7559f8bbdffae184529"))
			}
		
			it("Can be derived with path 44/60/0/0/4") {
				let correctSeed = "8b2868665a92d1043b55f9ccbfb4b2d2fcfd7e2111c16b0d51cef0983f95a9438f643cef3cc41277331f3da0e957110be1bc6a80771613859ea2999bbeea2876"
				let pk = PrivateKey(seed: Data(hex: correctSeed))

				guard let key = try? pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 4) else {
					fatalError()
				}
				expect(key.raw.toHexString()).to(equal("4c8c915475566f3da0b2fc1016dd26d06e56e63a3e7f84e65a22951070cdd4ba"))
			}
		}
	}
}
