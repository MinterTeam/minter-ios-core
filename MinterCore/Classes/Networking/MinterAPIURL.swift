//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation



let MinterAPIBaseURL: String! = MinterCoreSDK.shared.url!.absoluteString


public enum MinterAPIURL {
	
	case blocks
	
	case events
	
	case address
	
	case unconfirmedTransactions
	case transaction
	case transactions
	
	case coinInfo
	case estimateCoinBuy
	case estimateCoinSell
	case estimateTxCommission
	
	case blockNumber
	
	case status
	
	case sendTransaction
	
	case candidate
	
	case candidates
	
	case validators
	
	
	func url() -> URL {
		
		guard nil != MinterAPIBaseURL && nil != URL(string: MinterAPIBaseURL) else {
			fatalError("MinterCore must be initialized. Please call MinterCoreSDK.initialize(url:) first")
		}
		
		switch self {
			
		case .blocks:
			return URL(string: MinterAPIBaseURL + "/block")!
			
		case .events:
			return URL(string: MinterAPIBaseURL + "/events")!
			
		case .status:
			return URL(string: MinterAPIBaseURL + "/status")!
			
		case .address:
			return URL(string: MinterAPIBaseURL + "/address")!
			
		case .coinInfo:
			return URL(string: MinterAPIBaseURL + "/coin_info")!
			
		case .unconfirmedTransactions:
			return URL(string: MinterAPIBaseURL + "/unconfirmed_txs")!
			
		case .transaction:
			return URL(string: MinterAPIBaseURL + "/transaction")!
			
		case .transactions:
			return URL(string: MinterAPIBaseURL + "/transactions")!
			
		case .sendTransaction:
			return URL(string: MinterAPIBaseURL + "/send_transaction")!

		case .blockNumber:
			return URL(string: MinterAPIBaseURL + "/status")!
			
		case .estimateCoinSell:
			return URL(string: MinterAPIBaseURL + "/estimate_coin_sell")!
			
		case .estimateCoinBuy:
			return URL(string: MinterAPIBaseURL + "/estimate_coin_buy")!
			
		case .candidate:
			return URL(string: MinterAPIBaseURL + "/candidate")!
			
		case .candidates:
			return URL(string: MinterAPIBaseURL + "/candidates")!
			
		case .validators:
			return URL(string: MinterAPIBaseURL + "/validators")!
			
		case .estimateTxCommission:
			return URL(string: MinterAPIBaseURL + "/estimate_tx_commission")!
			
		}
	}
}
