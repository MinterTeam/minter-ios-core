//
//  SellCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 10/07/2018.
//

import Foundation
import BigInt


/// `SellCoinRawTransaction` is a transaction for selling one coin (owned by sender) in favour of another coin
/// in a system.
/// - SeeAlso: https://docs.minter.network/#section/Transactions/Sell-coin-transaction
public class SellCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasPrice: Int = RawTransactionDefaultGasPrice, gasCoin: String, data: Data) {
		
		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		self.init(nonce: nonce, gasPrice: BigUInt(gasPrice), gasCoin: coinData, type: RawTransactionType.sellCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasPrice: Int = RawTransactionDefaultGasPrice, gasCoin: String, coinFrom: String, coinTo: String, value: BigUInt, minimumValueToBuy: BigUInt) {
		let encodedData = SellCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, minimumValueToBuy: minimumValueToBuy).encode() ?? Data()
		self.init(nonce: nonce, gasPrice: gasPrice, gasCoin: gasCoin, data: encodedData)
	}

}

/// `SellCoinRawTransactionData` class
public struct SellCoinRawTransactionData: Encodable, Decodable {
	
	/// Coin symbol (e.g. "MNT")
	public var coinFrom: String
	/// Coin symbol (e.g. "BELTCOIN")
	public var coinTo: String
	/// Value in pip
	public var value: BigUInt
	/// Minimum value to buy
	public var minimumValueToBuy: BigUInt
	
	// MARK: -
	
	public init(coinFrom: String, coinTo: String, value: BigUInt, minimumValueToBuy: BigUInt) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
		self.value = value
		self.minimumValueToBuy = minimumValueToBuy
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.coinFrom = try values.decode(String.self, forKey: .coinFrom)
		self.coinTo = try values.decode(String.self, forKey: .coinTo)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
		case value
		case minimumValueToBuy
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
		try container.encode(value, forKey: .value)
		try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [fromCoinData, value, toCoinData, minimumValueToBuy] as [Any]
		return RLP.encode(fields)
	}
}



/// `SellAllCoinsRawTransaction` is a transaction for selling all existing coins of one type (owned by sender)
/// in favour of another coin in a system.
/// - SeeAlso: https://docs.minter.network/#section/Transactions/Sell-all-coin-transaction
public class SellAllCoinsRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasPrice: Int = RawTransactionDefaultGasPrice, gasCoin: String, data: Data) {
		
		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		self.init(nonce: nonce, gasPrice: BigUInt(gasPrice), gasCoin: coinData, type: RawTransactionType.sellAllCoins.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasPrice: Int = RawTransactionDefaultGasPrice, gasCoin: String, coinFrom: String, coinTo: String, minimumValueToBuy: BigUInt) {
		
		let encodedData = SellAllCoinsRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, minimumValueToBuy: minimumValueToBuy).encode() ?? Data()
		self.init(nonce: nonce, gasPrice: gasPrice, gasCoin: gasCoin, data: encodedData)
	}

}

/// SellAllCoinsRawTransactionData class
public struct SellAllCoinsRawTransactionData: Encodable, Decodable {
	
	/// Coin you'd like to sell
	public var coinFrom: String
	/// Coin you'd like to get
	public var coinTo: String
	/// Minimum value to sell
	var minimumValueToBuy: BigUInt
	
	// MARK: -
	
	public init(coinFrom: String, coinTo: String, minimumValueToBuy: BigUInt) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
		self.minimumValueToBuy = minimumValueToBuy
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.coinFrom = try values.decode(String.self, forKey: .coinFrom)
		self.coinTo = try values.decode(String.self, forKey: .coinTo)
		self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
		case minimumValueToBuy
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
		try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [fromCoinData, toCoinData, minimumValueToBuy] as [Any]
		return RLP.encode(fields)
	}
}
