//
//  DelegateRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// DelegateRawTransaction
public class DelegateRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.delegate.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - publicKey: Validator's public key
	///   - coin: Coin which you'd like to delegate
	///   - value: How much you'd like to delegate
	public convenience init(nonce: BigUInt, gasCoin: Data, publicKey: String, coin: String, value: BigUInt) {
		
		let encodedData = DelegateRawTransactionData(publicKey: publicKey, coin: coin, value: value).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
}

/// DelegateRawTransactionData
public struct DelegateRawTransactionData : Encodable {
	
	/// Validator's public key
	public var publicKey: String
	
	/// Coin you delegate (e.g. "MNT")
	public var coin: String
	
	/// Amount
	public var value: BigUInt
	
	//MARK: -
	
	public init(publicKey: String, coin: String, value: BigUInt) {
		self.publicKey = publicKey
		self.coin = coin
		self.value = value
	}
	
	//MARK: - Encoding
	
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
	
	public func encode() -> Data? {
		
		let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [Data(hex: publicKey), coinData, value] as [Any]
		return RLP.encode(fields)
	}
	
}
