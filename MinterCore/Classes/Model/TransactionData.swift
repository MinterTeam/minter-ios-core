//
//  TransactionData.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 10/07/2018.
//

import Foundation
import ObjectMapper

public class TransactionData {
	public var from: String?
	public var to: String?
}

public class SendCoinTransactionData: TransactionData {
	public var coin: Coin?
	public var amount: Decimal?
}

public class SendCoinTransactionDataMappable: SendCoinTransactionData, Mappable {

	required public init?(map: Map) {
		super.init()

		mapping(map: map)
	}

	public func mapping(map: Map) {
		to <- (map["to"], AddressTransformer())
		from <- (map["from"], AddressTransformer())
		amount <- (map["amount"], DecimalTransformer())
    coin = Mapper<CoinMappable>().map(JSONObject: map.JSON["coin"])
	}
}

public class ConvertTransactionData: TransactionData {
	public var fromCoin: Coin?
	public var toCoin: Coin?
	public var value: Decimal?
}

public class ConvertTransactionDataMappable: ConvertTransactionData, Mappable {
	
	required public init?(map: Map) {
		super.init()
		
		mapping(map: map)
	}
	
	public func mapping(map: Map) {
    fromCoin = Mapper<CoinMappable>().map(JSONObject: map.JSON["coin_to_sell"])
		toCoin = Mapper<CoinMappable>().map(JSONObject: map.JSON["coin_to_buy"])
		value <- (map["value"], DecimalTransformer())
		from <- (map["from"], AddressTransformer())
		to <- (map["from"], AddressTransformer())
	}
}

public class SellAllCoinsTransactionData: TransactionData {
	public var fromCoin: Coin?
	public var toCoin: Coin?
}

public class SellAllCoinsTransactionDataMappable: SellAllCoinsTransactionData, Mappable {
	
	required public init?(map: Map) {
		super.init()
		
		mapping(map: map)
	}
	
	public func mapping(map: Map) {
		to <- (map["from"], AddressTransformer())
		from <- (map["from"], AddressTransformer())
		fromCoin = Mapper<CoinMappable>().map(JSONObject: map.JSON["coin_to_sell"])
		toCoin = Mapper<CoinMappable>().map(JSONObject: map.JSON["coin_to_buy"])
	}
}
