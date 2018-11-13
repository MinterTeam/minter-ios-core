//
//  String+Helper.swift
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


class StringHelperSpec: QuickSpec {
	
	override func spec() {
		
		describe("String Mnemonic Tests") {
			
			it("Can generate mnemonic phrase") {
				let str = String.generateMnemonicString()
				expect(str).toNot(beNil())
				
				expect(str?.split(separator: " ").count).to(equal(12))
				
			}
			
			it("Can get seed from mnemonic") {
				
				let mnemonic = "globe arrange forget twice potato nurse ice dwarf arctic piano scorpion tube"
				let correctSeed = "e4d6956689cfba26aab4156e5f4600f5f386cdd56ea57f1bfdb40f33048d4d463989c170738ae582f07227af9fd707b40cc7d7d6fd24d14a4ee1e0f45928940d"
				let seed = String.seedString(mnemonic)
				expect(seed).to(equal(correctSeed))
			}
			
		}
		
		
		
		describe("String Helper Tests") {
			
			it("Should strip Mx prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("Mx" + base).stripMinterHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mx prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("MX" + base).stripMinterHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mx prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("mX" + base).stripMinterHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mx prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("mx" + base).stripMinterHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mx prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("" + base).stripMinterHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mc prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("" + base).stripMinterCheckHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mc prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("Mc" + base).stripMinterCheckHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mc prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("MC" + base).stripMinterCheckHexPrefix()
				expect(val).to(equal(base))
			}
			
			it("Should strip Mc prefix") {
				let base = "fsdfsdfdsfsdf"
				let val = ("mC" + base).stripMinterCheckHexPrefix()
				expect(val).to(equal(base))
			}
			
		}
		
	}
}
