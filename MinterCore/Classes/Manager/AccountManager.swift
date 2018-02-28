//
//  AccountManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


public class AccountManager : BaseManager {
	
	public func balance(address: String, with completion: (([String : Any]?, Error?) -> ())) {
		
		let balanceURL = MinterAPIURL.getBalance.url()
		
		self.httpClient.postRequest(balanceURL, parameters: ["address" : address]) { (response, error) in
			print(response.code)
			print(response.result)
			print(error)
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
