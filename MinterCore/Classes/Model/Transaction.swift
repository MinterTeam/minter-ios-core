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

	let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd HH:mm:ss+zzzz", locale: Locale.current.identifier)
	
	/// Transaction type
	public enum TransactionType: String {
		case send = "send"
		case buy = "buyCoin"
		case sell = "sellCoin"
		case sellAllCoins = "sellAllCoin"
	}
	
	public init() {}
	
	public var hash: String?
	public var type: TransactionType?
	public var txn: Int?
	public var data: TransactionData?
	public var date: Date?
}

class TransactionMappable : Transaction, Mappable {
	
	//MARK: - Mappable
	
	required init?(map: Map) {
		super.init()
		
		mapping(map: map)
	}
	
	func mapping(map: Map) {
		self.hash <- map["hash"]
		self.type <- map["type"]
		self.txn <- map["txn"]
		
		if nil != type, let data = map.JSON["data"] as? [String : Any] {
			switch type! {
			case .buy:
				self.data = Mapper<ConvertTransactionDataMappable>().map(JSON: data)
				break
				
			case .sell:
				self.data = Mapper<ConvertTransactionDataMappable>().map(JSON: data)
				break
				
			case .sellAllCoins:
				self.data = Mapper<SellAllCoinsTransactionDataMappable>().map(JSON: data)
				break
				
			case .send:
				self.data = Mapper<SendCoinTransactionDataMappable>().map(JSON: data)
				break
			}
		}
		self.date <- (map["date"], DateTransform())
	}

	//MARK: -
}
