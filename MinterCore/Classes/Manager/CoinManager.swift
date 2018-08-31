//
//  CoinManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper
import BigInt


public enum CoinManagerError : Error {
	case wrongAmount
	/// Estimate can't be parsed or something
	case noEstimate
}

/// Coin Manager Class cointains methods to work with coins
public class CoinManager : BaseManager {

	/**
	Method retreives coin info
	- Parameters:
	- symbol: Coin symbol e.g. MNT
	- completion: Method which will be called after request finished
	- Precondition: symbol must be uppercased (e.g. MNT)
	*/
	public func info(symbol: String, completion: ((Coin?, Error?) -> ())?) {
		
		let url = MinterAPIURL.coinInfo(coin: symbol).url()
		
		self.httpClient.getRequest(url, parameters: nil) { (response, error) in
			
			var coin: Coin?
			var err: Error?
			
			defer {
				completion?(coin, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			guard let resultPayload = response.data as? [String : Any] else {
				err = BaseManagerError.badResponse
				return
			}
			
			coin = Mapper<CoinMappable>().map(JSON: resultPayload)
		}
	}
	
	/**
	Method retreives buy coin estimate data from the Minter node
	- Parameters:
	- from: Coin symbol which you'd like to sell (e.g. MNT)
	- to: Coin symbol you'd like to buy (e.g. BELTCOIN)
	- amount: How many coins you'd like to buy (e.g. 1000000000000000000)
	- completion: Method which will be called after request finished. Completion method contans: How many coins you will pay, estimate commission, error if occured.
	- Precondition: `from` and `to` must be uppercased (e.g. MNT, BLTCOIN, etc.)
	*/
	public func estimateCoinBuy(from: String, to: String, amount: Decimal, completion: ((Decimal?, Decimal?, Error?) -> ())?) {
		
		let url = MinterAPIURL.estimateCoinBuy.url()
		
		guard let value = BigUInt(decimal: amount) else {
			completion?(nil, nil, CoinManagerError.wrongAmount)
			return
		}
		
		self.httpClient.getRequest(url, parameters: ["coin_to_sell" : from, "coin_to_buy" : to, "value_to_buy" : value]) { (response, error) in
			
			var value: Decimal?
			var comission: Decimal?
			var err: Error?
			
			defer {
				completion?(value, comission, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let estimatePayload = response.data as? [String : Any], let willGet = estimatePayload["will_pay"] as? String, let commission = estimatePayload["commission"] as? String {
				
				let willPay = Decimal(string: willGet)
				let com = Decimal(string: commission)
				
				guard nil != willPay && nil != com else {
					err = CoinManagerError.noEstimate
					return
				}
				
				value = willPay
				comission = com
			}
			else {
				err = BaseManagerError.badResponse
			}
		}
	}
	
	/**
	Method retreives sell coin estimate data from the Minter node
	- Parameters:
	- from: Coin symbol which you'd like to sell (e.g. MNT)
	- to: Coin symbol you'd like to buy (e.g. BELTCOIN)
	- amount: How many coins you'd like to sell (e.g. 1000000000000000000)
	- completion: Method which will be called after request finished. Completion method contans: How many coins you will get, estimate commission, error if occured.
	- Precondition: `from` and `to` should be uppercased (e.g. MNT, BLTCOIN, etc.)
	*/
	public func estimateCoinSell(from: String, to: String, amount: Decimal, completion: ((Decimal?, Decimal?, Error?) -> ())?) {
		
		let url = MinterAPIURL.estimateCoinSell.url()
		
		guard let value = BigUInt(decimal: amount) else {
			completion?(nil, nil, CoinManagerError.wrongAmount)
			return
		}
		
		self.httpClient.getRequest(url, parameters: ["coin_to_sell" : from, "coin_to_buy" : to, "value_to_sell" : value]) { (response, error) in
			
			var value: Decimal?
			var comission: Decimal?
			var err: Error?
			
			defer {
				completion?(value, comission, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let estimatePayload = response.data as? [String : Any], let willGet = estimatePayload["will_get"] as? String, let commission = estimatePayload["commission"] as? String {
				
				let willGet = Decimal(string: willGet)
				let com = Decimal(string: commission)
				
				guard nil != willGet, nil != com else {
					err = CoinManagerError.noEstimate
					return
				}
				
				value = willGet
				comission = com
			}
			else {
				err = BaseManagerError.badResponse
			}
		}
	}
	
	
	/// Method to calculate comission depend on signed rawTx
	///
	/// - Parameters:
	///   - rawTx: Signed raw Tx
	///   - completion: Method which will be called after request completed
	public func estimateTxCommission(rawTx: String, completion: ( (Decimal?, Error?) -> ())? ) {
		
		let url = MinterAPIURL.estimateTxCommission.url()
		
		self.httpClient.getRequest(url, parameters: ["tx" : rawTx]) { (response, error) in
			
			var comission: Decimal?
			var err: Error?
			
			defer {
				completion?(comission, err)
			}
			
			if let payload = response.data as? [String : Any], let commission = payload["commission"] as? String {
				comission = Decimal(string: commission)
			}
			else {
				err = BaseManagerError.badResponse
			}

		}
	}

}
