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
		
		let url = MinterAPIURL.transactions.url()
		
		self.httpClient.getRequest(url, parameters: ["query" : query]) { (response, error) in
			
			var transactions = [Transaction]()
			var err: Error?
			
			defer {
				completion?(transactions, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let res = response.data as? [[String : Any]] {
				transactions = Mapper<TransactionMappable>().mapArray(JSONArray: res)
			}
			else {
				transactions = []
				err = TransactionManagerError.transactionsIncorrectPayload
			}
		}
	}
	
	public func transaction(hash: String, completion: ((Transaction?, Error?) -> ())?) {
		
		let url = MinterAPIURL.transaction.url()
		
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
			
			if let res = response.data as? [String : Any] {
				transaction = Mapper<TransactionMappable>().map(JSON: res)
			}
		}
	}
	
	public func send(tx: String, completion: ((String?, String?, Error?) -> ())?) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.postRequest(url, parameters: ["transaction" : tx]) { (response, error) in
			
			var hash: String?
			var err: Error?
			var resultText: String?
			
			defer {
				completion?(hash, resultText, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			hash = response.data as? String
			
			resultText = response.data as? String
			
		}
	}
	
	public func transactionCount(address: String, completion: ((Int?, Error?) -> ())?) {
		
		let url = MinterAPIURL.transactionCount(address: address).url()
		
		self.httpClient.getRequest(url, parameters: nil) { (response, error) in
			
			var count: Int?
			var err: Error?
			
			defer {
				completion?(count, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let res = response.data as? Int {
				count = res
			}
		}
	}
	
}
