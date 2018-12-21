//
//  Base58Tests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 13/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore

class Base58Spec: QuickSpec {
	
	override func spec() {
		describe("Data") {
			it("Data fullHexString") {
				let str = "184ac726059e43643e67290666f7b3195093f870"
				
				let data = Data(hex: str)
				expect(data.fullHexString).to(equal(str))
			}
			
			it("Can retreive bytes from the string") {
				let valid = "3Sqz2ij3hiJD2gZQdaka7jXaiVvdwg9FmDGmVBrs7QNkEFRv15RB2cF"
				let str = "184ac726059e43643e67290666f7b3195093f870"
				
				let data = Base58.base58FromBytes(str.bytes)
				expect(data).to(equal(valid))
			}
			
			it("Can retreive bytes from the string") {
				let str = "3Sqz2ij3hiJD2gZQdaka7jXaiVvdwg9FmDGmVBrs7QNkEFRv15RB2cF"
				let valid: [UInt8] = [49, 56, 52, 97, 99, 55, 50, 54, 48, 53, 57, 101, 52, 51, 54, 52, 51, 101, 54, 55, 50, 57, 48, 54, 54, 54, 102, 55, 98, 51, 49, 57, 53, 48, 57, 51, 102, 56, 55, 48]
				
				let data = Base58.bytesFromBase58(str)
				expect(data).to(equal(valid))
			}
			
			//Array
			
			it("Can retreive bytes from the string") {
				let valid = "3Sqz2ij3hiJD2gZQdaka7jXaiVvdwg9FmDGmVBrs7QNkEFRv15RB2cF"
				
				let bytes: [UInt8] = [49, 56, 52, 97, 99, 55, 50, 54, 48, 53, 57, 101, 52, 51, 54, 52, 51, 101, 54, 55, 50, 57, 48, 54, 54, 54, 102, 55, 98, 51, 49, 57, 53, 48, 57, 51, 102, 56, 55, 48]
				
				let res = bytes.base58EncodedString
				
				expect(res).to(equal(valid))
			}
			
		}
	}
	
}

//fullHexString

