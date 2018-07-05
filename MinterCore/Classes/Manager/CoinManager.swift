//
//  CoinManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper
import BigInt



public class CoinManager : BaseManager {

	public func info(symbol: String, completion: ((Coin?, Error?) -> ())?) {
		
		let url = MinterAPIURL.coinInfo.url()
		
		self.httpClient.postRequest(url, parameters: ["coin" : symbol]) { (response, error) in
			
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
				err = BadResponse()
				return
			}
			
			coin = Mapper<CoinMappable>().map(JSON: resultPayload)
		}
	}
	
	public func estimateExchangeReturn(from: String, to: String, amount: Double, completion: ((Double?, Error?) -> ())?) {
		
		let url = MinterAPIURL.estimateCoinExchangeReturn.url()
		
		self.httpClient.getRequest(url, parameters: ["from_coin" : from, "to_coin" : to, "value" : BigUInt(amount * TransactionCoinFactor)]) { (response, error) in
			
			var resp: Double?
			var err: Error?
			
			defer {
				completion?(resp, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let estimate = response.data as? String {
				
				let vv = (Double(BigInt(stringLiteral: estimate))/TransactionCoinFactor).rounded(toPlaces: 8)
				
				resp = vv
			}
		}
	}

}
