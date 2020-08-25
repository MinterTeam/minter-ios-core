//
//  BuyCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 09/08/2018.
//

import Foundation
import BigInt

/// `BuyCoinRawTransaction` is a transaction for buing a coin paying another coin (owned by sender).
/// - SeeAlso: https://docs.minter.network/#section/Transactions/Buy-coin-transaction
public class BuyCoinRawTransaction: RawTransaction {

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///		- data: Encoded data to be send (Can be obtained by encoding BuyCoinRawTransactionData instance)
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(gasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.buyCoin.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoinId: Coin to spend fee from
	///   - coinFromId: Coin which you'd like to spend
	///   - coinToId: Coin which you'd like to buy
	///   - value: How much you'd like to buy
	///   - maximumValueToSell: Maximum value of coins to sell.
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													coinFromId: Int,
													coinToId: Int,
													value: BigUInt,
													maximumValueToSell: BigUInt) {

		let encodedData = BuyCoinRawTransactionData(coinFromId: coinFromId,
																								coinToId: coinToId,
																								value: value,
																								maximumValueToSell: maximumValueToSell).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: gasPrice,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - coinFrom: Coin which you'd like to spend
	///   - coinTo: Coin which you'd like to buy
	///   - value: How much you'd like to buy
	///   - maximumValueToSell: Maximum value of coins to sell.
//	public convenience init(nonce: BigUInt,
//													chainId: Int = MinterCoreSDK.shared.network.rawValue,
//													gasPrice: Int = RawTransactionDefaultGasPrice,
//													gasCoinId: Int,
//													coinFrom: String,
//													coinTo: String,
//													value: BigUInt,
//													maximumValueToSell: BigUInt) {
//
//		let encodedData = BuyCoinRawTransactionData(coinFrom: coinFrom,
//																								coinTo: coinTo,
//																								value: value,
//																								maximumValueToSell: maximumValueToSell).encode() ?? Data()
//		self.init(nonce: nonce,
//							chainId: chainId,
//							gasPrice: gasPrice,
//							gasCoinId: gasCoinId,
//							data: encodedData)
//	}

}

/// BuyCoinRawTransactionData
public struct BuyCoinRawTransactionData: Encodable, Decodable {
	/// Coin you sell (e.g. 0)
	public var coinFromId: Int
	/// Coin you buy (e.g. 1)
	public var coinToId: Int
	/// Amount
	public var value: BigUInt
	/// Maximum value to buy
	public var maximumValueToSell: BigUInt

	// MARK: -

	public init(coinFromId: Int,
							coinToId: Int,
							value: BigUInt,
							maximumValueToSell: BigUInt) {
		self.coinFromId = coinFromId
		self.coinToId = coinToId
		self.value = value
		self.maximumValueToSell = maximumValueToSell
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.coinFromId = try values.decode(Int.self, forKey: .coinFromId)
		self.coinToId = try values.decode(Int.self, forKey: .coinToId)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.maximumValueToSell = try values.decode(BigUInt.self, forKey: .maximumValueToSell)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case coinFromId
		case coinToId
		case value
		case maximumValueToSell
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFromId, forKey: .coinFromId)
		try container.encode(coinToId, forKey: .coinToId)
		try container.encode(value, forKey: .value)
		try container.encode(maximumValueToSell, forKey: .maximumValueToSell)
	}

	public func encode() -> Data? {
		let fields = [coinToId, value, coinFromId, maximumValueToSell] as [Any]
		return RLP.encode(fields)
	}

}
