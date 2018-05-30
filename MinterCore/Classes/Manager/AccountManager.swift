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
	
	public func balance(address: String, with completion: (([String : Any]?, Error?) -> ())?) {
		
		let balanceURL = MinterAPIURL.balance(address: address).url()
		
		self.httpClient.getRequest(balanceURL, parameters: nil) { (response, error) in
			
			var res: [String : Any]?
			var err: Error?
			
			defer {
				completion?(res, err)
			}
			
			guard nil == error else {
				err = error
				return
			}
			
			guard let balance = response.data as? [String : Any] else {
				err = AccountManagerError.balanceIncorrectPayload
				return
			}
			
			res = balance
			
		}
	}
	
	public func getTransactionCount(address: String, with completion: (([String : Any]?, Error?) -> ())) {
		
		let url = MinterAPIURL.transactionCount(address: address).url()
		
		self.httpClient.postRequest(url, parameters: nil) { (response, error) in
			print(response.code)
			print(response.data)
			print(error)
		}
	}
	
	public func sendTransactionCount(transaction: String, with completion: (([String : Any]?, Error?) -> ())) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["transaction" : transaction]) { (response, error) in
			print(response.code)
			print(response.data)
			print(error)
		}
	}

}
