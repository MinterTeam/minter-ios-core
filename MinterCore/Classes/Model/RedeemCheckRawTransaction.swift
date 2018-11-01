//
//  RedeemCheckRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation


public class RedeemCheckRawTransaction : RawTransaction {
	
}

public struct RedeemCheckRawTransactionData : Encodable {
	
	public var rawCheck: Data
	
	public var proof: Data
	
	public init(rawCheck: Data, proof: Data) {
		self.rawCheck = rawCheck
		self.proof = proof
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case rawCheck
		case proof
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(rawCheck, forKey: .rawCheck)
		try container.encode(proof, forKey: .proof)
	}
	
	public func encode() -> Data? {
		
		let fields = [rawCheck, proof] as [Any]
		return RLP.encode(fields)
	}
	
	
}
