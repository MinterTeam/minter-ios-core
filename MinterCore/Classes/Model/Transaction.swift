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
	public var type: Int?
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
		self.type <- map["type"]
		self.data <- map["data"]
		self.payload <- map["payload"]
	}
}
