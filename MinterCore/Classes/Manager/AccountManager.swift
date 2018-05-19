//
//  AccountManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation

enum AccountManagerError : Error {
	case balanceIncorrectPayload
	
}


public class AccountManager : BaseManager {
	
	public func balance(address: String, with completion: @escaping (([String : Any]?, Error?) -> ())) {
		
		let balanceURL = MinterAPIURL.balance(address: "Mx" + address).url()
		
		self.httpClient.getRequest(balanceURL, parameters: nil) { (response, error) in
			
			var res: [String : Any]?
			var err: Error?
			
			defer {
				completion(res, err)
			}
			
			guard nil == error else {
				err = error
				return
			}
			
			guard let balance = response.result as? [String : Any] else {
				err = AccountManagerError.balanceIncorrectPayload
				return
			}
			
			res = balance
			
		}
	}
	
	public func getTransactionCount(address: String, with completion: (([String : Any]?, Error?) -> ())) {
		
		let url = MinterAPIURL.getTransactionCount.url()
		
		self.httpClient.postRequest(url, parameters: ["address" : address]) { (response, error) in
			print(response.code)
			print(response.result)
			print(error)
		}
	}
	
	public func sendTransactionCount(transaction: String, with completion: (([String : Any]?, Error?) -> ())) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["transaction" : transaction]) { (response, error) in
			print(response.code)
			print(response.result)
			print(error)
		}
	}

}
