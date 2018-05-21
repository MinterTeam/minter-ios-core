//
//  Transaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper

open class Transaction {
	
	public enum TransactionType: String {
		case sendCoin = "sendCoin"
	}
	
	public init() {
		
	}
	
	public var hash: String?
	public var type: TransactionType?
	public var from: String?
	public var to: String?
	public var coinSymbol: String?
	public var value: Float?
}

class TransactionMappable : Transaction, Mappable {
	
	//MARK: - Mappable
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		self.hash <- map["hash"]
		self.type <- map["type"]
		self.from <- map["from"]
		self.to <- map["data.to"]
		self.coinSymbol <- map["data.coin"]
		self.value <- map["data.value"]
	}

	//MARK: -
}
