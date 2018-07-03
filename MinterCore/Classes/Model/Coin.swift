//
//  Coin.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper

public class Coin {
	
	public var name: String?
	public var symbol: String?
	public var volume: Int?
	public var crr: Double?
	public var reserveCoin: String?
	public var reserveBalance: Int?
	public var creator: String?
}

class CoinMappable : Coin, Mappable {
	
	required init?(map: Map) {

	}
	
	func mapping(map: Map) {
		self.name <- map["name"]
		self.symbol <- map["symbol"]
		self.volume <- map["volume"]
		self.crr <- map["crr"]
		self.reserveCoin <- map["reserve_coin"]
		self.reserveBalance <- map["reserve_balance"]
		self.creator <- map["creator"]
	}

}

public extension Coin {
	
	public static func defaultCoin() -> Coin {
		let coin = Coin()
		coin.name = "MINT"
		coin.symbol = "MNT"
		return coin
	}
	
}
