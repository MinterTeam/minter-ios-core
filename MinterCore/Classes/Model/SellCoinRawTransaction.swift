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
public class SellCoinRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(gasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.sellCoin.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													coinFromId: Int,
													coinToId: Int,
													value: BigUInt,
													minimumValueToBuy: BigUInt) {

		let encodedData = SellCoinRawTransactionData(coinFromId: coinFromId,
																								 coinToId: coinToId,
																								 value: value,
																								 minimumValueToBuy: minimumValueToBuy)
			.encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: gasPrice,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// `SellCoinRawTransactionData` class
public struct SellCoinRawTransactionData: Encodable, Decodable {

	/// Coin symbol (e.g. 0)
	public var coinFromId: Int
	/// Coin symbol (e.g. 1)
	public var coinToId: Int
	/// Value in pip
	public var value: BigUInt
	/// Minimum value to buy
	public var minimumValueToBuy: BigUInt

	// MARK: -

	public init(coinFromId: Int,
							coinToId: Int,
							value: BigUInt,
							minimumValueToBuy: BigUInt) {
		self.coinFromId = coinFromId
		self.coinToId = coinToId
		self.value = value
		self.minimumValueToBuy = minimumValueToBuy
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.coinFromId = try values.decode(Int.self, forKey: .coinFromId)
		self.coinToId = try values.decode(Int.self, forKey: .coinToId)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case coinFromId
		case coinToId
		case value
		case minimumValueToBuy
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFromId, forKey: .coinFromId)
		try container.encode(coinToId, forKey: .coinToId)
		try container.encode(value, forKey: .value)
		try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
	}

	public func encode() -> Data? {
		let fields = [coinFromId, value, coinToId, minimumValueToBuy] as [Any]
		return RLP.encode(fields)
	}
}

/// `SellAllCoinsRawTransaction` is a transaction for selling all existing coins of one type (owned by sender)
/// in favour of another coin in a system.
/// - SeeAlso: https://docs.minter.network/#section/Transactions/Sell-all-coin-transaction
public class SellAllCoinsRawTransaction : RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													data: Data) {
		
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(gasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.sellAllCoins.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													coinFromId: Int,
													coinToId: Int,
													minimumValueToBuy: BigUInt) {
		
		let encodedData = SellAllCoinsRawTransactionData(coinFromId: coinFromId,
																										 coinToId: coinToId,
																										 minimumValueToBuy: minimumValueToBuy).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: gasPrice,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// SellAllCoinsRawTransactionData class
public struct SellAllCoinsRawTransactionData: Encodable, Decodable {

	/// Coin you'd like to sell
	public var coinFromId: Int
	/// Coin you'd like to get
	public var coinToId: Int
	/// Minimum value to sell
	var minimumValueToBuy: BigUInt

	// MARK: -

	public init(coinFromId: Int,
							coinToId: Int,
							minimumValueToBuy: BigUInt) {
		self.coinFromId = coinFromId
		self.coinToId = coinToId
		self.minimumValueToBuy = minimumValueToBuy
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.coinFromId = try values.decode(Int.self, forKey: .coinFromId)
		self.coinToId = try values.decode(Int.self, forKey: .coinToId)
		self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case coinFromId
		case coinToId
		case minimumValueToBuy
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFromId, forKey: .coinFromId)
		try container.encode(coinToId, forKey: .coinToId)
		try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
	}

	public func encode() -> Data? {
		let fields = [coinFromId, coinToId, minimumValueToBuy] as [Any]
		return RLP.encode(fields)
	}
}
