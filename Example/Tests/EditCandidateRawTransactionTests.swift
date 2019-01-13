//
//  EditCandidateRawTransactionTests.swift
//  MinterCore_Tests
//
//  Created by Alexey Sidorov on 13/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import MinterCore
import ObjectMapper
import BigInt


class EditCandidateRawTransactionTestsSpec: BaseQuickSpec {
	
	override func spec() {
		describe("EditCandidateRawTransaction Model") {
			
			it("Can initialize it's data") {
				let pk = "Mpc5b635cde82f796d1f8320efb8ec634f443e6b533a973570e4b5ea04aa44e96d"
				let address1 = "Mxe7ca647d17599d3e83048830fbb2df3726a7d22c"
				let address2 = "Mxa8ca647d17599d3e83048830fbb2df3726a7d215"
				
				let data = EditCandidateRawTransactionData(publicKey: pk, rewardAddress: address1, ownerAddress: address2)
				
				expect(data).toNot(beNil())
				expect(data?.publicKey).to(equal(pk))
				expect(data?.rewardAddress).to(equal(address1))
				expect(data?.ownerAddress).to(equal(address2))
			}
			
			it("Can be initialized") {
				
				let pk = "Mpc5b635cde82f796d1f8320efb8ec634f443e6b533a973570e4b5ea04aa44e96d"
				let address = "Mxc22d7a6273fd2bbf03884038e3d99571d746ac7e"
				
				let data = EditCandidateRawTransactionData(publicKey: pk, rewardAddress: address, ownerAddress: address)?.encode()
				
				let model = EditCandidateRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", publicKey: pk, rewardAddress: address, ownerAddress: address)
				
				expect(model).toNot(beNil())
				expect(model?.data).to(equal(data))
			}
			
		}
	}
}
