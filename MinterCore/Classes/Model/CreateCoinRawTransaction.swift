//
//  CreateCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// CreateCoinRawTransaction
public class CreateCoinRawTransaction : RawTransaction {
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - data: Encoded CreateCoinRawTransactionData instance
	public convenience init(nonce: BigUInt, gasCoin: String, data: Data) {
		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		self.init(nonce: nonce, gasPrice: RawTransactionDefaultGasPrice, gasCoin: coinData, type: RawTransactionType.createCoin.BigUIntValue(), payload: Data(), serviceData: Data())
		self.data = data
	}
	
	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - gasCoin: Coin to spend fee from
	///   - name: Coin name
	///   - symbol: Coin symbol
	///   - initialAmount: Coin initial amount
	///   - initialReserve: Coin reserve balance
	///		- reserveRatio: Coin reserve ratio in percent (e.g. 10%)
	public convenience init(nonce: BigUInt, gasCoin: String, name: String, symbol: String, initialAmount: BigUInt, initialReserve: BigUInt, reserveRatio: BigUInt) {
		let encodedData = CreateCoinRawTransactionData(name: name, symbol: symbol, initialAmount: initialAmount, initialReserve: initialReserve, reserveRatio: reserveRatio).encode() ?? Data()
		self.init(nonce: nonce, gasCoin: gasCoin, data: encodedData)
	}
	
}

/// CreateCoinRawTransactionData
public struct CreateCoinRawTransactionData : Encodable, Decodable {
	
	/// Coin name (e.g. Belt Coin)
	public var name: String
	
	/// Coin symbol (e.g. "BELTCOIN")
	public var symbol: String
	
	/// Initial Amount (e.g. 100)
	public var initialAmount: BigUInt
	
	/// Initial Reserve (e.g. 100)
	public var initialReserve: BigUInt
	
	/// Reserve Ratio (e.g. 10%)
	public var reserveRatio: BigUInt
	
	//MARK: -
	
	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		self.name = try values.decode(String.self, forKey: .name)
		self.symbol = try values.decode(String.self, forKey: .symbol)
		self.initialAmount = try values.decode(BigUInt.self, forKey: .initialAmount)
		self.initialReserve = try values.decode(BigUInt.self, forKey: .initialReserve)
		self.reserveRatio = try values.decode(BigUInt.self, forKey: .reserveRatio)
	}
	
	///  Initializer
	///
	/// - Parameters:
	///   - name: Coin name
	///   - symbol: Coin symbol
	///   - initialAmount: Coin initial amount
	///   - initialReserve: Coin reserve balance
	///		- reserveRatio: Coin reserve ratio in percent (e.g. 10%)
	public init(name: String, symbol: String, initialAmount: BigUInt, initialReserve: BigUInt, reserveRatio: BigUInt) {
		self.name = name
		self.symbol = symbol
		self.initialAmount = initialAmount
		self.initialReserve = initialReserve
		self.reserveRatio = reserveRatio
	}
	
	//MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case name
		case symbol
		case initialAmount
		case initialReserve
		case reserveRatio
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(name, forKey: .name)
		try container.encode(symbol, forKey: .symbol)
		try container.encode(initialAmount, forKey: .initialAmount)
		try container.encode(initialReserve, forKey: .initialReserve)
		try container.encode(reserveRatio, forKey: .reserveRatio)
	}
	
	//MARK: - RLP Encoding
	
	public func encode() -> Data? {
		
		let coinData = symbol.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [name, coinData, initialAmount, initialReserve, reserveRatio] as [Any]
		return RLP.encode(fields)
	}
	
}
