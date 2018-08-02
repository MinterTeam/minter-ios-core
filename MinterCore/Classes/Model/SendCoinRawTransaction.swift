//
//  SendCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 29/05/2018.
//

import Foundation
import BigInt


public class SendCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: BigUInt(1), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, to: String, value: BigUInt, coin: String) {
		
		let encodedData = SendCoinRawTransactionData(to: to, value: value, coin: coin).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
	
}
