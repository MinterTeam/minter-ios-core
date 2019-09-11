//
//  UnbondRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// UnbondRawTransaction
public class UnbondRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoin: Data,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(1),
							gasCoin: gasCoin,
							type: RawTransactionType.unbond.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - publicKey: Validator's public key
	///   - coin: Coin which you'd like to unbond
	///   - value: How much you'd like to unbond
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoin: Data,
													publicKey: String,
													coin: String,
													value: BigUInt) {

		let encodedData = UnbondRawTransactionData(publicKey: publicKey,
																							 coin: coin,
																							 value: value).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasCoin: gasCoin,
							data: encodedData)
	}

}

/// UnbondRawTransactionData
public struct UnbondRawTransactionData: Encodable, Decodable {

	/// Validator's public key
	public var publicKey: String

	/// Coin you unbond (e.g. "MNT")
	public var coin: String

	/// Amount to unbond
	public var value: BigUInt

	// MARK: -

	public init(publicKey: String, coin: String, value: BigUInt) {
		self.publicKey = publicKey
		self.coin = coin
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.publicKey = try values.decode(String.self, forKey: .publicKey)
		self.coin = try values.decode(String.self, forKey: .coin)
		self.value = try values.decode(BigUInt.self, forKey: .value)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case publicKey
		case coin
		case value
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(publicKey, forKey: .publicKey)
		try container.encode(coin, forKey: .coin)
		try container.encode(value, forKey: .value)
	}

	// MARK: - RLPEncoding

	public func encode() -> Data? {
		let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let fields = [Data(hex: publicKey), coinData, value] as [Any]
		return RLP.encode(fields)
	}

}
