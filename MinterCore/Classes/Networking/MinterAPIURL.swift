//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation



let MinterAPIBaseURL: String! = MinterCoreSDK.shared.url?.absoluteString


public enum MinterAPIURL {
	
	case balance(address: String)
	
	case transaction(hash: String)
	case transactionCount(address: String)
	
	case coinInfo(coin: String)
	case estimateCoinBuy
	case estimateCoinSell
	case estimateTxCommission
	
	
	case blockNumber
	
	case status
	
	case bipVolume
	
	case sendTransaction
	
	case candidate(publicKey: String)
	
	case validators
	
	
	func url() -> URL {
		
		guard nil != MinterAPIBaseURL && nil != URL(string: MinterAPIBaseURL) else {
			fatalError("MinterCore must be initialized. Please call MinterCoreSDK.initialize(url:) first")
		}
		
		switch self {
			
		case .status:
			return URL(string: MinterAPIBaseURL + "status/")!
			
		case .bipVolume:
			return URL(string: MinterAPIBaseURL + "bipVolume/")!
			
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
			
		case .candidate(let publicKey):
			return URL(string: MinterAPIBaseURL + "candidate/" + publicKey.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!
			
		case .validators:
			return URL(string: MinterAPIBaseURL + "validators/")!
			
		case .estimateTxCommission:
			return URL(string: MinterAPIBaseURL + "estimateTxCommission")!
			
		}
	}
}
