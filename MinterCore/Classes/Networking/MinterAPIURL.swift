//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation


//let MinterAPIBaseURL = "https://minter-testnet.dl-dev.ru/api/"
let MinterAPIBaseURL = "http://92.53.87.101:8841/api/"


public enum MinterAPIURL {
	
	case balance(address: String)
	
	case transaction
	case transactions
	case transactionCount(address: String)
	
	case coinInfo
	case estimateCoinExchangeReturn
	
	case blockNumber
	
	case sendTransaction
	
	
	func url() -> URL {
		switch self {
			
		case .balance(let address):
			return URL(string: MinterAPIBaseURL + "balance/" + address)!

		case .transactions:
			return URL(string: MinterAPIBaseURL + "transactions")!
			
		case .transactionCount(let address):
			return URL(string: MinterAPIBaseURL + "transactionCount/" + address)!
			
		case .coinInfo:
			return URL(string: MinterAPIBaseURL + "coinInfo")!
			
		case .estimateCoinExchangeReturn:
			return URL(string: MinterAPIBaseURL + "estimateCoinExchangeReturn")!
			
		case .transaction:
			return URL(string: MinterAPIBaseURL + "transaction")!
			
		case .sendTransaction:
			return URL(string: MinterAPIBaseURL + "sendTransaction")!

		case .blockNumber:
			return URL(string: MinterAPIBaseURL + "status")!
			
		}
	}
}
