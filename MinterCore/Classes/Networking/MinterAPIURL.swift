//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation



//let MinterAPIBaseURL = "https://minter-testnet.dl-dev.ru/api/"
let MinterAPIBaseURL = "http://minter-node-2.testnet.minter.network:8841/api/"


public enum MinterAPIURL {
	
	case balance(address: String)
	
	case transaction(hash: String)
	case transactionCount(address: String)
	
	case coinInfo(coin: String)
	case estimateCoinBuy
	case estimateCoinSell
	
	
	case blockNumber
	
	case sendTransaction
	
	
	func url() -> URL {
		switch self {
			
		case .balance(let address):
			return URL(string: MinterAPIBaseURL + "balance/" + address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!
			
		case .transactionCount(let address):
			return URL(string: MinterAPIBaseURL + "transactionCount/" + address.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!
			
		case .coinInfo(let coin):
			return URL(string: MinterAPIBaseURL + "coinInfo/" + coin.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!
			
		case .transaction(let hash):
			return URL(string: MinterAPIBaseURL + "transaction/" + hash.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!
			
		case .sendTransaction:
			return URL(string: MinterAPIBaseURL + "sendTransaction")!

		case .blockNumber:
			return URL(string: MinterAPIBaseURL + "status")!
			
		case .estimateCoinSell:
			return URL(string: MinterAPIBaseURL + "estimateCoinSell")!
			
		case .estimateCoinBuy:
			return URL(string: MinterAPIBaseURL + "estimateCoinBuy")!
			
			
		}
	}
}
