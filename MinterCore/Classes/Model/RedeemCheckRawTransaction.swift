//
//  RedeemCheckRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// Redeem check transaction
public class RedeemCheckRawTransaction : RawTransaction {
	
	//MARK: -
	
	///
	public init?(nonce: BigUInt = BigUInt(1),
							 chainId: Int = MinterCoreSDK.shared.network.rawValue,
							 gasCoin: String,
							 rawCheck: Data,
							 proof: Data) {
		
		guard let gsCoin = gasCoin.data(using: .utf8)?.setLengthRight(10), let data = RedeemCheckRawTransactionData(rawCheck: rawCheck, proof: proof).encode() else {
			return nil
		}
		
		super.init(nonce: nonce, chainId: chainId, gasCoin: gsCoin, type: RawTransactionType.redeemCheck.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	required public init(from decoder: Decoder) throws {
		try super.init(from: decoder)
	}

}

/// Redeem check transaction data
public struct RedeemCheckRawTransactionData : Encodable, Decodable {
	
	/// Raw Check data
	/// Can be made with RawTransactionSigner.
	public var rawCheck: Data
	
	/// Proof data
	/// Can be made with RawTransactionSigner.proof(address: "Mx..", passphrase: "pass")
	public var proof: Data
	
	public init(rawCheck: Data, proof: Data) {
		self.rawCheck = rawCheck
		self.proof = proof
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.rawCheck = try values.decode(Data.self, forKey: .rawCheck)
		self.proof = try values.decode(Data.self, forKey: .proof)
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
	
	// MARK: - RLP Encode
	
	public func encode() -> Data? {
		
		let fields = [rawCheck, proof] as [Any]
		return RLP.encode(fields)
	}
	
	
}
