//
//  RawTransaction
//  MinterCore
//
//  Created by Alexey Sidorov on 30/03/2018.
//

import Foundation
import Alamofire
import BigInt

public protocol RLPEncodable : Encodable {
	func encode() -> Data?
}

public protocol SignatureRLPEncodable : RLPEncodable {
	func encode(forSignature: Bool) -> Data?
}

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

/// Transaction type
/// - SeeAlso: https://minter-go-node.readthedocs.io/en/docs/transactions.html#types
public enum RawTransactionType {
	case sendCoin
	case sellCoin
	case sellAllCoins
	case buyCoin
	case createCoin
	case declareCandidacy
	case delegate
	case unbond
	case redeemCheck
	case setCandidateOnline
	case setCandidateOffline
	
	public func BigUIntValue() -> BigUInt {
		switch self {
		case .sendCoin:
			return BigUInt(1)
			
		case .sellCoin:
			return BigUInt(2)
			
		case .sellAllCoins:
			return BigUInt(3)
			
		case .buyCoin:
			return BigUInt(4)
			
		case .createCoin:
			return BigUInt(5)
			
		case .declareCandidacy:
			return BigUInt(6)
			
		case .delegate:
			return BigUInt(7)
			
		case .unbond:
			return BigUInt(8)
			
		case .redeemCheck:
			return BigUInt(9)
			
		case .setCandidateOnline:
			return BigUInt(10)
			
		case .setCandidateOffline:
			return BigUInt(11)
		}
	}
	
	/// Comission for a transaction in pips
	/// - SeeAlso: https://minter-go-node.readthedocs.io/en/docs/commissions.html
	public func commission() -> Decimal {
		switch self {
		case .sendCoin: return 0.01 * TransactionCoinFactorDecimal
		case .sellCoin, .buyCoin, .sellAllCoins: return 0.1 * TransactionCoinFactorDecimal
		case .createCoin: return 1 * TransactionCoinFactorDecimal
		case .declareCandidacy: return 10  * TransactionCoinFactorDecimal
		case .delegate: return 0.1 * TransactionCoinFactorDecimal
		case .unbond: return 0.1 * TransactionCoinFactorDecimal
		case .redeemCheck: return 0.01 * TransactionCoinFactorDecimal
		case .setCandidateOnline: return 0.1 * TransactionCoinFactorDecimal
		case .setCandidateOffline: return 0.1 * TransactionCoinFactorDecimal
		}
	}


}

/// A base class for all RawTransactions
open class RawTransaction : Encodable, SignatureRLPEncodable {
	
	public struct SignatureData : Encodable, RLPEncodable {
		
		public var v: BigUInt
		public var s: BigUInt
		public var r: BigUInt
		
		public init(v: BigUInt = BigUInt(1), r: BigUInt = BigUInt(0), s: BigUInt = BigUInt(0)) {
			self.v = v
			self.r = r
			self.s = s
		}
		
		// MARK: - RLPEncodable
		
		public func encode() -> Data? {
			let fields = [self.v, self.r, self.s] as [Any]
			return RLP.encode(fields)
		}
		
		// MARK: - Encodable
		
		enum CodingKeys: String, CodingKey {
			case v
			case r
			case s
		}
		
		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(v, forKey: .v)
			try container.encode(r, forKey: .r)
			try container.encode(s, forKey: .s)
		}
		
	}
	
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
	
	public var signatureType: BigUInt
	
	public var signatureData: RLPEncodable
	
//	/// ECDSA fields. Digital signature of TX
//	public var v: BigUInt = BigUInt(1)
//	public var r: BigUInt = BigUInt(0)
//	public var s: BigUInt = BigUInt(0)
	
	// MARK: -
	
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
	public init(nonce: BigUInt, gasPrice: BigUInt, gasCoin: Data, type: BigUInt, data: Data = Data(), payload: Data, serviceData: Data, signatureType: BigUInt = BigUInt(1), signatureData: RLPEncodable = SignatureData()) {
		self.nonce = nonce
		self.gasPrice = gasPrice
		self.gasCoin = gasCoin
		self.type = type
		self.data = data
		self.payload = payload
		self.serviceData = serviceData
		self.signatureType = signatureType
		self.signatureData = signatureData
	}
	
	// MARK: - Encodable
	
	enum CodingKeys: String, CodingKey {
		case nonce
		case gasPrice
		case gasCoin
		case type
		case data
		case payload
		case serviceData
		case signatureType
		case signatureData
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
		try container.encode(signatureType, forKey: .signatureType)
		try container.encode(signatureData, forKey: .signatureData)
	}
	
	//MARK: - SignatureRLPEncodable
	
	public func encode(forSignature: Bool = false) -> Data? {
		
		if (forSignature) {
			
			let fields = [self.nonce, self.gasPrice, self.gasCoin, self.type, self.data, self.payload, self.serviceData, self.signatureType] as [Any]
			return RLP.encode(fields)
		}
		else {
			
			let fields = [self.nonce, self.gasPrice, self.gasCoin, self.type, self.data, self.payload, self.serviceData, self.signatureType, self.signatureData.encode() ?? Data()] as [Any]
			return RLP.encode(fields)
		}
	}
	
	//MARK: - RLPEncodable
	
	public func encode() -> Data? {
		return self.encode(forSignature: false)
	}
	
}
