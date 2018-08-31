//
//  Coin.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper


/// Coin Model
public class Coin {
	
	/// Coin name (e.g. Belt Coin)
	public var name: String?
	
	/// Coin symbol (e.g. BELTCOIN)
	public var symbol: String?
	
	/// Coin volume value (e.g. 1000000000000000000000)
	public var volume: String?
	
	/// Coin Reserve Ratio (e.g. 10)
	public var crr: Double?
	
	/// Reserve Balance (e.g. 10000000000000000000)
	public var reserveBalance: Decimal?
	
	/// Creator`s address (e.g. Mx8aecc99090e22db1ae017a739b0dc0beb63dbee8)
	public var creator: String?
}

/// Internal use Coin mappable class
class CoinMappable : Coin, Mappable {
	
	
	/**
	Coin Model Initializer
	- Parameters:
	- map: Map object to initialize from
	- Returns: CoinMappable instance
	*/
	required init?(map: Map) {
		super.init()
		
		self.mapping(map: map)
	}
	
	// MARK: - ObjectMapper
	
	func mapping(map: Map) {
		self.name <- map["name"]
		self.symbol <- map["symbol"]
		self.volume <- map["volume"]
		self.crr <- map["crr"]
		self.reserveBalance <- map["reserve_balance"]
		if let strReserveValue = map.JSON["reserve_balance"] as? String, reserveBalance == nil {
			self.reserveBalance = Decimal(string: strReserveValue)
		}
		self.creator <- map["creator"]
	}

}

public extension Coin {
	
	/// Base coin model, differs depend on the network (testnet, mainnet)
	public static func baseCoin() -> Coin {
		let coin = Coin()
		coin.name = "MINT"
		coin.symbol = "MNT"
		return coin
	}
	
}
