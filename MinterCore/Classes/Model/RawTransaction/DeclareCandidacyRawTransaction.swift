//
//  DeclareCandidacyRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// DeclareCandidacyRawTransaction
public class DeclareCandidacyRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(1),
							gasCoinId: gasCoinId,
							type: RawTransactionType.declareCandidacy.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													address: String,
													publicKey: String,
													commission: BigUInt,
													coinId: Int,
													stake: BigUInt) {

		let encodedData = DeclareCandidacyRawTransactionData(address: address,
																												 publicKey: publicKey,
																												 commission: commission,
																												 coinId: coinId,
																												 stake: stake).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// DeclareCandidacyRawTransactionData
public struct DeclareCandidacyRawTransactionData: Encodable, Decodable {

	/// Address to get reward to
	public var address: String

	/// Validator's public key
	public var publicKey: String

	/// Comission (up to 100%)
	public var commission: BigUInt

	/// Coin you declare (e.g. 0)
	public var coinId: Int

	/// Stake
	public var stake: BigUInt

	// MARK: -

	public init(address: String,
							publicKey: String,
							commission: BigUInt,
							coinId: Int,
							stake: BigUInt) {
		self.address = address
		self.publicKey = publicKey
		self.commission = commission
		self.coinId = coinId
		self.stake = stake
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.address = try values.decode(String.self, forKey: .address)
		self.publicKey = try values.decode(String.self, forKey: .publicKey)
		self.commission = try values.decode(BigUInt.self, forKey: .commission)
		self.coinId = try values.decode(Int.self, forKey: .coinId)
		self.stake = try values.decode(BigUInt.self, forKey: .stake)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case address
		case publicKey
		case commission
		case coinId
		case stake
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(address, forKey: .address)
		try container.encode(publicKey, forKey: .publicKey)
		try container.encode(commission, forKey: .commission)
		try container.encode(coinId, forKey: .coinId)
		try container.encode(stake, forKey: .stake)
	}

	// MARK: - RLPEncoding

	public func encode() -> Data? {
		let pub = Data(hex: publicKey.stripMinterHexPrefix())
		let adrs = Data(hex: address.stripMinterHexPrefix())
		let fields = [adrs, pub, commission, coinId, stake] as [Any]
		return RLP.encode(fields)
	}
}
