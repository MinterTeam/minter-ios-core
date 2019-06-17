//
//  Transaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper
import BigInt

public let TransactionCoinFactor = BigUInt(stringLiteral: "1000000000000000000")
public let TransactionCoinFactorDecimal = pow(10, 18)

/// Transaction type
public enum TransactionType: Int {
	case send = 1
	case sell = 2
	case sellAll = 3
	case buy = 4
	case create = 5
	case declare = 6
	case delegate = 7
	case unbond = 8
	case redeemCheck = 9
	case setCandidateOnline = 10
	case setCandidateOffline = 11
	case createMultisig = 12
	case multisend = 13
	case editCandidate = 14
}

/// Transaction Model
open class Transaction {

	public init() {}

	// MARK: -

	public var hash: String?
	public var rawTx: String?
	public var height: Int?
	public var index: Int?
	public var txResult: [String : Any]?
	public var from: String?
	public var nonce: Int?
	public var gasPrice: Int?
	public var type: TransactionType?
	public var data: [String : Any]?
	public var payload: String?
}

class TransactionMappable : Transaction, Mappable {

	// MARK: - Mappable

	required init?(map: Map) {
		super.init()

		mapping(map: map)
	}

	func mapping(map: Map) {
		self.hash <- map["hash"]
		self.rawTx <- map["raw_tx"]
		self.height <- map["height"]
		self.index <- map["index"]
		self.txResult <- map["tx_result"]
		self.from <- map["from"]
		self.nonce <- map["nonce"]
		self.gasPrice <- map["gas_price"]
		self.type <- (map["type"], TransactionTypeTransformer())
		self.data <- map["data"]
		self.payload <- map["payload"]
	}
}
