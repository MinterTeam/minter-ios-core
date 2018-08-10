//
//  BuyCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 09/08/2018.
//

import Foundation
import BigInt


/// BuyCoinRawTransaction
public class BuyCoinRawTransaction : RawTransaction {
	
	public convenience init(nonce: BigUInt, gasCoin: Data, data: Data) {
		
		self.init(nonce: nonce, gasPrice: BigUInt(1), gasCoin: gasCoin, type: RawTransactionType.buyCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - coinFrom: Coin which you'd like to spend
	///   - coinTo: Coin which you'd like to buy
	///   - value: How much you'd like to buy
	public convenience init(nonce: BigUInt, gasCoin: Data, coinFrom: String, coinTo: String, value: BigUInt) {
		
		let encodedData = BuyCoinRawTransactionData(coinFrom: coinFrom, coinTo: coinTo, value: value).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
}

/// BuyCoinRawTransactionData
public struct BuyCoinRawTransactionData : Encodable {
	
	/// Coin you sell (e.g. "MNT")
	public var coinFrom: String
	
	/// Coin you buy (e.g. "BELTCOIN")
	public var coinTo: String
	
	/// Amount yo
	public var value: BigUInt
	
	//MARK: -
	
	public init(coinFrom: String, coinTo: String, value: BigUInt) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
		self.value = value
	}
	
	//MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
		case value
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
		try container.encode(value, forKey: .value)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [toCoinData, value, fromCoinData] as [Any]
		return RLP.encode(fields)
	}
	
}
