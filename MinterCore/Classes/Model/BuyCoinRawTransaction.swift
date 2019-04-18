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
public class BuyCoinRawTransaction : RawTransaction {

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///		- data: Encoded data to be send (Can be obtained by encoding BuyCoinRawTransactionData instance)
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoin: Data,
													data: Data) {

		self.init(nonce: nonce, chainId: chainId, gasPrice: BigUInt(gasPrice), gasCoin: gasCoin, type: RawTransactionType.buyCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
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
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoin: Data,
													coinFrom: String,
													coinTo: String,
													value: BigUInt,
													maximumValueToSell: BigUInt) {

		let encodedData = BuyCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value, maximumValueToSell: maximumValueToSell).encode() ?? Data()
		self.init(nonce: nonce, chainId: chainId, gasPrice: gasPrice, gasCoin: gasCoin, data: encodedData)
	}

}

/// BuyCoinRawTransactionData
public struct BuyCoinRawTransactionData : Encodable, Decodable {

	/// Coin you sell (e.g. "MNT")
	public var coinFrom: String

	/// Coin you buy (e.g. "BELTCOIN")
	public var coinTo: String

	/// Amount
	public var value: BigUInt

	/// Maximum value to buy
	public var maximumValueToSell: BigUInt

	// MARK: -

	public init(coinFrom: String, coinTo: String, value: BigUInt, maximumValueToSell: BigUInt) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
		self.value = value
		self.maximumValueToSell = maximumValueToSell
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.coinFrom = try values.decode(String.self, forKey: .coinFrom)
		self.coinTo = try values.decode(String.self, forKey: .coinTo)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.maximumValueToSell = try values.decode(BigUInt.self, forKey: .maximumValueToSell)
	}

	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
		case value
		case maximumValueToSell
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
		try container.encode(value, forKey: .value)
		try container.encode(maximumValueToSell, forKey: .maximumValueToSell)
	}

	public func encode() -> Data? {
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let fields = [toCoinData, value, fromCoinData, maximumValueToSell] as [Any]
		return RLP.encode(fields)
	}

}
