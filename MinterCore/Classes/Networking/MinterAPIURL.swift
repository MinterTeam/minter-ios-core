//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation


//let MinterAPIBaseURL = "https://minter-testnet.dl-dev.ru/api/"
let MinterAPIBaseURL = "http://159.89.107.246:8841/api/"


public enum MinterAPIURL {
	
	case balance(address: String)
	case getTransactions(query: String)
	case getTransactionCount
	case getCoinInfo
	case estimateCoinExchangeReturn
	case getTransaction
	case blockNumber
	case sendTransaction
	
	
	func url() -> URL {
		switch self {
		case .balance(let address):
			return URL(string: MinterAPIBaseURL + "balance/" + address)!

		case .getTransactions(let query):
			let url = URL(string: MinterAPIBaseURL + "transactions")!
			var components = URLComponents(string: url.absoluteString)
			components?.queryItems = [URLQueryItem(name: "query", value: query)]
			return components!.url!
			
		case .getTransactionCount:
			return URL(string: MinterAPIBaseURL + "transactionCount")!
			
		case .getCoinInfo:
			return URL(string: MinterAPIBaseURL + "coinInfo")!
			
		case .estimateCoinExchangeReturn:
			return URL(string: MinterAPIBaseURL + "estimateCoinExchangeReturn")!
			
		case .getTransaction:
			return URL(string: MinterAPIBaseURL + "transaction")!
			
		case .sendTransaction:
			return URL(string: MinterAPIBaseURL + "sendTransaction")!

		case .blockNumber:
			return URL(string: MinterAPIBaseURL + "staus")!
			
		}
	}
}
