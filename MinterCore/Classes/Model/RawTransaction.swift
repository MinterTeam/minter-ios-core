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
		//TODO: -
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

/// A base class for all RawTransactions
open class RawTransaction : Encodable {
	
	/// Used for prevent transaction reply
	public var nonce: BigUInt
	/// Used for managing transaction fees
	public var gasPrice: BigUInt = RawTransactionDefaultGasPrice
	/// Coin which will be used to get commission from
	public var gasCoin: Data
	/// Transaction type
	/// - SeeAlso: https://minter-go-node.readthedocs.io/en/docs/transactions.html#types
	public var type: BigUInt = BigUInt(1)
	/// Data encoded with RLP, the contents of its depend on the Tx type
	public var data: Data
	/// Arbitrary user-defined bytes
	/// Using this field requires an extra commission (about 1 pip per byte)
	public var payload: Data
	/// Reserved field
	/// Using this field requires an extra commission (about 1 pip per byte)
	public var serviceData: Data
	
	/// ECDSA fields. Digital signature of TX
	public var v: BigUInt = BigUInt(1)
	public var r: BigUInt = BigUInt(0)
	public var s: BigUInt = BigUInt(0)
	
	//MARK: -
	
	/**
	RawTransaction initializer
	- Parameters:
	- nonce: BigUInt value of nonce
	- gasPrice: BigUInt value of price
	- gasCoin: Data
	- type: BigUInt value of transaction type
	- data: Transaction Data object
	- payload: Payload Data object
	- serviceData: ServiceData Data object
	- v, r, s: Digital signature
	- Precondition:
	- nonce value can be retreived from the Minter Network, for exmple by calling this method https://minter-go-node.readthedocs.io/en/docs/api.html#transaction-count
	- gasCoin: 10 bytes of coin symbol, if the byte count less than 10 add 0 bytes from the right (e.g. UInt8([77, 78, 84, 0, 0, 0, 0, 0, 0, 0])
	- data: RLP-encoded data
	- Returns: Signed RawTx hex string, which can be send to Minter Node
	*/
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

/// SendCoinRawTransactionData
public struct SendCoinRawTransactionData : Encodable {
	
	/// Address to whom you'd like to send coins
	public var to: String
	/// How many coins you'd like to send, the value should be in pip
	public var value: BigUInt
	/// Coin symbol (e.g. "MNT")
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

/// SellCoinRawTransactionData
public struct SellCoinRawTransactionData: Encodable {
	
	/// Coin symbol (e.g. "MNT")
	public var coinFrom: String
	/// Coin symbol (e.g. "BELTCOIN")
	public var coinTo: String
	/// Value in pip
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

/// SellAllCoinsRawTransactionData
public struct SellAllCoinsRawTransactionData: Encodable {
	
	/// Coin you'd like to sell
	public var coinFrom: String
	/// Coin you'd like to get
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

