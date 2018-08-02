//
//  TransactionManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper


public enum TransactionManagerError : Error {
	case transactionsIncorrectPayload
	case transactionSendError(code: Int?, message: String?)
}

///Transaction Manager class
public class CoreTransactionManager : BaseManager {
	
	//MARK: -
	
	/**
	Method retreives transaction info from Minter Node
	- Parameters:
	- hash: Transaction hash (e.g. Mt8aca4d57c014e23c9b3b4b9e44a0be0f539320ae)
	- completion: Method which will be called after request finished, contains `Transaction` and `Error` if occured
	*/
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
	
	/**
	Method to send raw transaction to Minter Node
	- Parameters:
	- tx: Raw Transaction hex (e.g. f869220103a0df8a4d4e54000000000000008805120d17260727768a5355504552434f494e0080801ca0b2f7c98ae6d7eeb1bcf66e6339cb19d402b7ee824890fb65ff998d9ebf279af5a0616a6319a416a47ecb2c36d97b02f1867456f5551d38f76eeb29b70b79bdf0e6)
	- completion: Method which will be called after request finished, contains Tx hash, status text and error if occured
	*/
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
			
			let data = response.data as? [String : Any]
			hash = data?["hash"] as? String
			//TODO: migrate to TransactionManagerError
			resultText = (err as? APIClient.APIClientResponseError)?.userData?["message"] as? String
		}
	}
	
	/**
	Method to retreive transactions count from Minter Node
	- Parameters:
	- address: minter address (e.g. Mx228e5a68b847d169da439ec15f727f08233a7ca6)
	- completion: Method which will be called after request finished, contains Tx count (nonce) and error if occured
	- Precondition: `address` should contain "Mx" prefix
	*/
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
			
			if let res = response.data as? [String : Any] {
				count = res["count"] as? Int
			}
		}
	}
	
}
