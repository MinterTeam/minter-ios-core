//
//  SendCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 29/05/2018.
//

import Foundation
import BigInt

/// SendCoinRawTransaction
public class SendCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.sendCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: String, data: Data) {
		
		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: coinData, type: RawTransactionType.sendCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	public convenience init(nonce: BigUInt, gasCoin: Data, to: String, value: BigUInt, coin: String) {
		
		let encodedData = SendCoinRawTransactionData(to: to, value: value, coin: coin).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
	
}

/// SendCoinRawTransactionData
public struct SendCoinRawTransactionData : Encodable, Decodable {
	
	/// Address to whom you'd like to send coins
	public var to: String
	/// How many coins you'd like to send, the value should be in pip
	public var value: BigUInt
	/// Coin symbol (e.g. "MNT")
	public var coin: String = RawTransactionDefaultTransactionCoin
	
	// MARK: -
	
	public init(to: String, value: BigUInt, coin: String) {
		self.to = to
		self.value = value
		self.coin = coin
	}
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.to = try values.decode(String.self, forKey: .to)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.coin = try values.decode(String.self, forKey: .coin)
	}
	
	// MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case to
		case value
		case coin
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(to, forKey: .to)
		try container.encode(value, forKey: .value)
		try container.encode(coin, forKey: .coin)
	}
	
	public func encode() -> Data? {
		let dataArray = Array<UInt8>(hex: self.to.lowercased().stripMinterHexPrefix())
		guard let toData = Data(dataArray).setLengthLeft(20) else {
			return Data()
		}
		
		let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [coinData, toData, value] as [Any]
		return RLP.encode(fields)
	}
}
