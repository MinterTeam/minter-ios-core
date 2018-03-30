//
//  Transaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper

public class Transaction {
	
	public enum TransactionType: String {
		case sendCoin = "sendCoin"
	}
	
	var hash: String?
	var type: TransactionType?
	var from: String?
	var to: String?
	var coinSymbol: String?
	var value: Float?
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
