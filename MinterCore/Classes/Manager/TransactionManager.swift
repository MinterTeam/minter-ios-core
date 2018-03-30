//
//  TransactionManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper


public class TransactionManager : BaseManager {
	
	//MARK: -
	
	public func transactions(address: String, completion: (([Transaction], Error?) -> ())?) {
		
		let url = MinterAPIURL.getTransactions.url()
		
		self.httpClient.postRequest(url, parameters: ["address" : address]) { (response, error) in
			
			var transactions = [Transaction]()
			var err: Error?
			
			defer {
				completion?(transactions, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let res = response.result as? [[String : Any]] {
				transactions = Mapper<TransactionMappable>().mapArray(JSONArray: res)
			}
			else {
				transactions = []
			}
		}
	}
	
	public func transaction(hash: String, completion: ((Transaction?, Error?) -> ())?) {
		
		let url = MinterAPIURL.getTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["hash" : hash]) { (response, error) in
			
			var transaction: Transaction?
			var err: Error?
			
			defer {
				completion?(transaction, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let res = response.result as? [String : Any] {
				transaction = Mapper<TransactionMappable>().map(JSON: res)
			}
		}
	}
	
	public func send(tx: String, completion: (() -> ())?) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["transaction" : tx]) { (response, error) in
			
			var transaction: Transaction?
			var err: Error?
			
			defer {
				completion?()
			}
			
			guard error == nil else {
				err = error
				return
			}
			
//			if let res = response.result as? [String : Any] {
//				transaction = Mapper<TransactionMappable>().map(JSON: res)
//			}
		}
	}
}
