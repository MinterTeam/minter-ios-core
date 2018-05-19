//
//  TransactionManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper

enum TransactionManagerError : Error {
	case transactionsIncorrectPayload
}


public class TransactionManager : BaseManager {
	
	//MARK: -
	
	public func transactions(address: String, query: String, completion: (([Transaction], Error?) -> ())?) {
		
		let url = MinterAPIURL.getTransactions(query: query).url()
		
		self.httpClient.getRequest(url, parameters: nil) { (response, error) in
			
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
				err = TransactionManagerError.transactionsIncorrectPayload
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
	
	public func send(tx: String, completion: ((Bool, Error?) -> ())?) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["transaction" : tx]) { (response, error) in
			
			var success: Bool = false
			var err: Error?
			
			defer {
				completion?(success, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			success = true
			
		}
	}
}
