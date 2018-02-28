//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation


let MinterAPIBaseURL = "http://minter-fake-api.dl-dev.ru:8841/api/"


enum MinterAPIURL {
	
	case getBalance
	case getTransactions
	case getTransactionCount
	case getCoinInfo
	case estimateCoinExchangeReturn
	case getTransaction
	case blockNumber
	case sendTransaction
	
	
	func url() -> URL {
		switch self {
		case .getBalance:
			return URL(string: MinterAPIBaseURL + "getBalance")!
			
		case .getTransactions:
			return URL(string: MinterAPIBaseURL + "getTransactions")!
			
		case .getTransactionCount:
			return URL(string: MinterAPIBaseURL + "getTransactionCount")!
			
		case .getCoinInfo:
			return URL(string: MinterAPIBaseURL + "getCoinInfo")!
			
		case .estimateCoinExchangeReturn:
			return URL(string: MinterAPIBaseURL + "estimateCoinExchangeReturn")!
			
		case .getTransaction:
			return URL(string: MinterAPIBaseURL + "getTransaction")!
			
		case .sendTransaction:
			return URL(string: MinterAPIBaseURL + "sendTransaction")!

		case .blockNumber:
			return URL(string: MinterAPIBaseURL + "blockNumber")!
			
		}
	}
}
