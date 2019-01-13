//
//  EditCandidateRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 12/01/2019.
//

import Foundation
import BigInt

/// EditCandidateRawTransaction class
public class EditCandidateRawTransaction : RawTransaction {
	
	public convenience init?(nonce: BigUInt, gasCoin: String, data: Data) {
		
		guard let gsCoin = gasCoin.data(using: .utf8)?.setLengthRight(10) else {
			return nil
		}
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gsCoin, type: RawTransactionType.editCandidate.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - publicKey: Candidate's public key
	///   - rewardAddress: Address to send reward to (e.g. Mx228e5a68b847d169da439ec15f727f08233a7ca6)
	///   - ownerAddress:
	public convenience init?(nonce: BigUInt, gasCoin: String, publicKey: String, rewardAddress: String, ownerAddress: String) {
		
		let encodedData = EditCandidateRawTransactionData(publicKey: publicKey, rewardAddress: rewardAddress, ownerAddress: ownerAddress)?.encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}

}

/// EditCandidateRawTransaction Data class
public struct EditCandidateRawTransactionData {
	
	/// Candidate's public key
	public var publicKey: String
	
	///
	public var rewardAddress: String
	
	///
	public var ownerAddress: String
	
	//MARK: -
	
	private var publicKeyData: Data = Data()
	private var rewardAddressData: Data = Data()
	private var ownerAddressData: Data = Data()
	
	
	//MARK: -
	
	public init?(publicKey: String, rewardAddress: String, ownerAddress: String) {
		self.publicKey = publicKey
		self.rewardAddress = rewardAddress
		self.ownerAddress = ownerAddress
		
		let pkData = Data(hex: publicKey.stripMinterHexPrefix())
		guard pkData.count > 0 else {
			return nil
		}
		self.publicKeyData = pkData
		
		let rewardData = Data(hex: rewardAddress.stripMinterHexPrefix())
		guard rewardData.count > 0 else {
			return nil
		}
		self.rewardAddressData = rewardData
		
		let ownerAddressData = Data(hex: ownerAddress.stripMinterHexPrefix())
		guard ownerAddressData.count > 0 else {
			return nil
		}
		self.ownerAddressData = ownerAddressData
		
	}
	
	//MARK: - RLPEncoding
	
	public func encode() -> Data? {
		
		let fields = [publicKeyData, rewardAddressData, ownerAddressData] as [Any]
		return RLP.encode(fields)
	}
	
}

