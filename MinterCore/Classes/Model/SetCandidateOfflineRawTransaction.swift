//
//  SetCandidateOfflineRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// SetCandidateOnlineRawTransaction
public class SetCandidateOfflineRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(1),
							gasCoinId: gasCoinId,
							type: RawTransactionType.setCandidateOffline.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													publicKey: String) {
		let encodedData = SetCandidateOfflineRawTransactionData(publicKey: publicKey).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// SetCandidateOfflineRawTransactionData
public struct SetCandidateOfflineRawTransactionData : Encodable, Decodable {

	/// Validator's public key
	public var publicKey: String

	// MARK: -

	public init(publicKey: String) {
		self.publicKey = publicKey
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.publicKey = try values.decode(String.self, forKey: .publicKey)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case publicKey
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(publicKey, forKey: .publicKey)
	}

	public func encode() -> Data? {
		let pk = publicKey.stripMinterHexPrefix()
		let pub = Data(hex: pk)
		let fields = [pub] as [Any]
		return RLP.encode(fields)
	}

}
