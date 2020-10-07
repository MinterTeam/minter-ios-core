//
//  SetCandidateOnlineRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// SetCandidateOnlineRawTransaction
public class SetCandidateOnlineRawTransaction : RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(RawTransactionDefaultGasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.setCandidateOnline.BigUIntValue(),
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
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoinId: Int,
													publicKey: String) {
		let encodedData = SetCandidateOnlineRawTransactionData(publicKey: publicKey).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// SetCandidateOnlineRawTransactionData
public struct SetCandidateOnlineRawTransactionData : Encodable, Decodable {

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

	// MARK: - RLPEncoding

	public func encode() -> Data? {
		let pk = publicKey.stripMinterHexPrefix()
		let pub = Data(hex: pk)
		let fields = [pub] as [Any]
		return RLP.encode(fields)
	}

}
