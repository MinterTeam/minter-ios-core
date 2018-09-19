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
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.unbond.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - publicKey: Validator's public key
	public convenience init(nonce: BigUInt, gasCoin: Data, publicKey: String) {
		
		let encodedData = SetCandidateOnlineRawTransactionData(publicKey: publicKey).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
}

/// SetCandidateOnlineRawTransactionData
public struct SetCandidateOnlineRawTransactionData : Encodable {
	
	/// Validator's public key
	public var publicKey: String
	
	//MARK: -
	
	public init(publicKey: String) {
		self.publicKey = publicKey
	}
	
	//MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case publicKey
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(publicKey, forKey: .publicKey)
	}
	
	public func encode() -> Data? {
		
		let fields = [publicKey] as [Any]
		return RLP.encode(fields)
	}
	
}
