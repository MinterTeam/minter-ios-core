//
//  SendCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 29/05/2018.
//

import Foundation
import BigInt


public class SendCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, data: Data) {
		
//		self.init(nonce: nonce, gasPrice: BigUInt(), type: BigUInt(1))
		self.init(nonce: nonce, gasPrice: BigUInt(1), type: BigUInt(1), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, to: String, value: BigUInt, coin: String) {
		
		let encodedData = RawTransactionData(to: to, value: value, coin: coin).encode() ?? Data()
		self.init(nonce: nonce, data: encodedData)
	}
	
	
}
