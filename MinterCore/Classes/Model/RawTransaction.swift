//
//  RawTransaction
//  MinterCore
//
//  Created by Alexey Sidorov on 30/03/2018.
//

import Foundation
import Alamofire
import BigInt


public enum TransactionHTTPClientResponseStatusCode : Int {
	case unknown = -1
	case noError = 0
	case coinNotFound = 200
	case insufficientFundsForTransaction = 300
	case nonceTooLow = 400
	case nonceTooHigh = 401
	case incorrenctSignture = 500
	case incorrenctTransactionData = 600
	case unknownError = 900
}

//TODO: Change depend on network!
let RawTransactionDefaultTransactionCoin = "MNT"

let RawTransactionDefaultGasPrice = BigUInt("1000000000", radix: 10)!


public enum TransactionCommisionType {
	case send
	case convert
	case createCoin
	case declareCandidacy
	case delegate
	case unbond
	case redeemCheck
	case setCandidateOnline
	case setCandidateOffline
	
	public func amount() -> Decimal {
		switch self {
		case .send: return 0.01 * TransactionCoinFactorDecimal
		case .convert: return 0.1 * TransactionCoinFactorDecimal
		case .createCoin: return 1
		case .declareCandidacy: return 1
		case .delegate: return 1
		case .unbond: return 1
		case .redeemCheck: return 1
		case .setCandidateOnline: return 1
		case .setCandidateOffline: return 1
		}
	}
	
}

open class RawTransaction : Encodable {
	
	public var nonce: BigUInt
	public var gasPrice: BigUInt = RawTransactionDefaultGasPrice
	public var gasCoin: Data
	public var type: BigUInt = BigUInt(1)
	public var data: Data
	public var payload: Data
	public var serviceData: Data
	public var v: BigUInt = BigUInt(1)
	public var r: BigUInt = BigUInt(0)
	public var s: BigUInt = BigUInt(0)
	
	//MARK: -
	
	public init(nonce: BigUInt, gasPrice: BigUInt, gasCoin: Data, type: BigUInt, data: Data = Data(), payload: Data, serviceData: Data, v: BigUInt = BigUInt(1), r: BigUInt = BigUInt(0), s: BigUInt = BigUInt(0)) {
		self.nonce = nonce
		self.gasPrice = gasPrice
		self.gasCoin = gasCoin
		self.type = type
		self.data = data
		self.payload = payload
		self.serviceData = serviceData
		self.v = v
		self.r = r
		self.s = s
	}
	
	//MARK: - Encodable
	
	enum CodingKeys: String, CodingKey {
		case nonce
		case gasPrice
		case gasCoin
		case type
		case data
		case payload
		case serviceData
		case v
		case r
		case s
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(nonce, forKey: .nonce)
		try container.encode(gasPrice, forKey: .gasPrice)
		try container.encode(gasCoin, forKey: .gasCoin)
		try container.encode(type, forKey: .type)
		try container.encode(data, forKey: .data)
		try container.encode(payload, forKey: .payload)
		try container.encode(serviceData, forKey: .serviceData)
		try container.encode(v, forKey: .v)
		try container.encode(r, forKey: .r)
		try container.encode(s, forKey: .s)
	}
	
	public func encode(forSignature: Bool = false) -> Data? {
		
		if (forSignature) {
			
			let fields = [self.nonce, self.gasPrice, self.gasCoin, self.type, self.data, self.payload, self.serviceData] as [Any]
			return RLP.encode(fields)
		}
		else {
			
			let fields = [self.nonce, self.gasPrice, self.gasCoin, self.type, self.data, self.payload, self.serviceData, self.v, self.r, self.s] as [Any]
			return RLP.encode(fields)
		}
	}
}

public struct SendCoinRawTransactionData : Encodable {
	
	public var to: String
	public var value: BigUInt
	public var coin: String = RawTransactionDefaultTransactionCoin
	
	//MARK: -
	
	public init(to: String, value: BigUInt, coin: String) {
		self.to = to
		self.value = value
		self.coin = coin
	}
	
	//MARK: - Encoding
	
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

public struct SellCoinRawTransactionData: Encodable {
	
	public var coinFrom: String
	public var coinTo: String
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
		
		let fields = [fromCoinData, value, toCoinData] as [Any]
		return RLP.encode(fields)
	}
}

public struct BuyCoinRawTransactionData : Encodable {
	public var coinFrom: String
	public var coinTo: String
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

public struct SellAllCoinsRawTransactionData: Encodable {
	
	public var coinFrom: String
	public var coinTo: String
	
	//MARK: -
	
	public init(coinFrom: String, coinTo: String) {
		self.coinFrom = coinFrom
		self.coinTo = coinTo
	}
	
	//MARK: - Encoding
	
	enum CodingKeys: String, CodingKey {
		case coinFrom
		case coinTo
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(coinFrom, forKey: .coinFrom)
		try container.encode(coinTo, forKey: .coinTo)
	}
	
	public func encode() -> Data? {
		
		let fromCoinData = coinFrom.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		let toCoinData = coinTo.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [fromCoinData, toCoinData] as [Any]
		return RLP.encode(fields)
	}
}

