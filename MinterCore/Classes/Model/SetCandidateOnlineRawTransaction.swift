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
	
	public convenience init(nonce: BigUInt, gasCoin: String, data: Data) {
		
		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		self.init(nonce: nonce, gasPrice: RawTransactionDefaultGasPrice, gasCoin: coinData, type: RawTransactionType.setCandidateOnline.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - publicKey: Validator's public key
	public convenience init(nonce: BigUInt, gasCoin: String, publicKey: String) {
		
		let encodedData = SetCandidateOnlineRawTransactionData(publicKey: publicKey).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
}

/// SetCandidateOnlineRawTransactionData
public struct SetCandidateOnlineRawTransactionData : Encodable, Decodable {
	
	/// Validator's public key
	public var publicKey: String
	
	//MARK: -
	
	public init(publicKey: String) {
		self.publicKey = publicKey
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.publicKey = try values.decode(String.self, forKey: .publicKey)
	}
	
	//MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case publicKey
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(publicKey, forKey: .publicKey)
	}
	
	//MARK: - RLPEncoding
	
	public func encode() -> Data? {
		
		let pk = publicKey.stripMinterHexPrefix()
		let pub = Data(hex: pk)
		let fields = [pub] as [Any]
		return RLP.encode(fields)
	}
	
}
