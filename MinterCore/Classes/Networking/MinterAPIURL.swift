//
//  MinterAPIURL.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation

let MinterAPIBaseURL: String! = MinterCoreSDK.shared.url!.absoluteString

public enum MinterAPIURL {

  case blocks(height: String)
  case events(height: String)

  case address(address: String)

	case unconfirmedTransactions
	case transaction
	case transactions

  case coinInfo(symbol: String)
	case estimateCoinBuy
	case estimateCoinSell
	case estimateCoinSellAll
	case estimateTxCommission

	case blockNumber

	case status

	case sendTransaction

  case candidate(publicKey: String)

	case candidates

	case validators

	func url() -> URL {

		guard nil != MinterAPIBaseURL && nil != URL(string: MinterAPIBaseURL) else {
			fatalError("MinterCore must be initialized. Please call MinterCoreSDK.initialize(url:) first")
		}

		switch self {

		case .blocks(let height):
			return URL(string: MinterAPIBaseURL + "/block/" + height)!

    case .events(let height):
			return URL(string: MinterAPIBaseURL + "/events/" + height)!

		case .status:
			return URL(string: MinterAPIBaseURL + "/status")!

		case .address(let address):
			return URL(string: MinterAPIBaseURL + "/address/" + address)!

		case .coinInfo(let symbol):
			return URL(string: MinterAPIBaseURL + "/coin_info/" + symbol)!

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

		case .estimateCoinSellAll:
			return URL(string: MinterAPIBaseURL + "/estimate_coin_sell_all")!

		case .estimateCoinBuy:
			return URL(string: MinterAPIBaseURL + "/estimate_coin_buy")!

		case .candidate(let publicKey):
			return URL(string: MinterAPIBaseURL + "/candidate/" + publicKey)!

		case .candidates:
			return URL(string: MinterAPIBaseURL + "/candidates")!

		case .validators:
			return URL(string: MinterAPIBaseURL + "/validators")!

		case .estimateTxCommission:
			return URL(string: MinterAPIBaseURL + "/estimate_tx_commission")!
		}
	}
}
