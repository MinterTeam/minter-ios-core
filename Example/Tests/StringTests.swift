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
			it("String+Mnemonic") {
				
			}
			
			it("Can generate mnemonic phrase") {
				let str = String.generateMnemonicString()
				expect(str).toNot(beNil())
				
				expect(str?.split(separator: " ").count).to(equal(12))
				
			}
			
			it("Can generate Private Key seed") {
//				String.privateKeyString(seed: )
				
				
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
			
		}
		
	}
}
