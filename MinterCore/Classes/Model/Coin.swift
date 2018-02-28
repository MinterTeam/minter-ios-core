//
//  Coin.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper

public class Coin {
	
	var name: String?
	var symbol: String?
	var volume: Int?
	var crr: Double?
	var reserveCoin: String?
	var reserveBalance: Int?
	var creator: String?
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
