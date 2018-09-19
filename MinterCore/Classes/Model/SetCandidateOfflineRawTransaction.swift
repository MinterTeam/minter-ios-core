//
//  SetCandidateOfflineRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// SetCandidateOnlineRawTransaction
public class SetCandidateOfflineRawTransaction : SetCandidateOnlineRawTransaction {}

/// SetCandidateOfflineRawTransactionData
public struct SetCandidateOfflineRawTransactionData : Encodable {
	
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

