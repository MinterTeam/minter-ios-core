//
//  CoinManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper


public class CoinManager : BaseManager {

	public func info(symbol: String, completion: ((Coin?, Error?) -> ())?) {
		
		let url = MinterAPIURL.getCoinInfo.url()
		
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
			
			guard let resultPayload = response.result as? [String : Any] else {
				err = BadResponse()
				return
			}
			
			coin = Mapper<CoinMappable>().map(JSON: resultPayload)
		}
	}
	
	public func estimateExchangeReturn(from: String, to: String, amount: Double, completion: ((Double?, Error?) -> ())?) {
		let url = MinterAPIURL.estimateCoinExchangeReturn.url()
		
		self.httpClient.postRequest(url, parameters: ["from_coin" : from, "to_coin" : to, "amount" : amount]) { (response, error) in
			
			var resp: Double?
			var err: Error?
			
			defer {
				completion?(resp, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let estimate = response.result as? Double {
				resp = estimate
			}
		}
	}

}
