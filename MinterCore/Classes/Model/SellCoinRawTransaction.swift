//
//  SellCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 10/07/2018.
//

import Foundation
import BigInt


/// SellCoinRawTransaction
public class SellCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.sellCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String, value: BigUInt) {
		
		let encodedData = SellCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}

/// SellCoinRawTransactionData
public struct SellCoinRawTransactionData: Encodable {
	
	/// Coin symbol (e.g. "MNT")
	public var coinFrom: String
	/// Coin symbol (e.g. "BELTCOIN")
	public var coinTo: String
	/// Value in pip
	public var value: BigUInt
	
	// MARK: -
	
	public init(coinFrom: String, coinTo: String, value: BigUInt) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
		self.value = value
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
		case value
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
		try container.encode(value, forKey: .value)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [fromCoinData, value, toCoinData] as [Any]
		return RLP.encode(fields)
	}
}



/// SellAllCoinsRawTransaction
public class SellAllCoinsRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.sellAllCoins.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String) {
		
		let encodedData = SellAllCoinsRawTransactionData(coinFrom: coinFrom, coinTo: coinTo).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}

// MARK: - SellAllCoinsRawTransactionData

/// SellAllCoinsRawTransactionData
public struct SellAllCoinsRawTransactionData: Encodable {
	
	/// Coin you'd like to sell
	public var coinFrom: String
	/// Coin you'd like to get
	public var coinTo: String
	
	// MARK: -
	
	public init(coinFrom: String, coinTo: String) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [fromCoinData, toCoinData] as [Any]
		return RLP.encode(fields)
	}
}
