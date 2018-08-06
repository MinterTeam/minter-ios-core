//
//  ConvertCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 10/07/2018.
//

import Foundation
import BigInt


/// SellCoinRawTransaction
public class SellCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: BigUInt(2), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String, value: BigUInt) {
		
		let encodedData = SellCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}

/// SellAllCoinsRawTransaction
public class SellAllCoinsRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: BigUInt(3), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String) {
		
		let encodedData = SellAllCoinsRawTransactionData(coinFrom: coinFrom, coinTo: coinTo).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}

/// BuyCoinRawTransaction
public class BuyCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: BigUInt(4), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String, value: BigUInt) {

		let encodedData = BuyCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}
