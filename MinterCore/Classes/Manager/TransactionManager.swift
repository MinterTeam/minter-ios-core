//
//  TransactionManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import ObjectMapper
import BigInt


public enum TransactionManagerError : Error {
	case transactionsIncorrectPayload
	case transactionSendError(code: Int?, message: String?)
}

///Transaction Manager class
public class TransactionManager : BaseManager {
	
	//MARK: -
	
	/**
	Method retreives transaction info from Minter Node
	- Parameters:
	- hash: Transaction hash (e.g. Mt8aca4d57c014e23c9b3b4b9e44a0be0f539320ae)
	- completion: Method which will be called after request finished, contains `Transaction` and `Error` if occured
	*/
	public func transaction(hash: String, completion: ((Transaction?, Error?) -> ())?) {
		
		let url = MinterAPIURL.transaction.url()
		
		self.httpClient.getRequest(url, parameters: ["hash" : hash]) { (response, error) in
			
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
	
	public func transaction(query: String, completion: (([Transaction]?, Error?) -> ())?) {
		
		let url = MinterAPIURL.transactions.url()
		
		self.httpClient.getRequest(url, parameters: ["query" : query]) { (response, error) in
			
			var transactions: [Transaction]?
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
		}
	}
	
	
	public func unconfirmedTransaction(limit: String = "0", completion: (([String : Any]?, Error?) -> ())?) {
		
		let url = MinterAPIURL.unconfirmedTransactions.url()
		
		self.httpClient.getRequest(url, parameters: ["limit" : limit]) { (response, error) in
			
			var transactions: [String : Any]?
			var err: Error?
			
			defer {
				completion?(transactions, err)
			}
			
			guard error == nil else {
				err = error
				return
			}
			
			if let res = response.data as? [String : Any] {
				transactions = res
			}
		}
	}
	
	/**
	Method to send raw transaction to a Minter Node
	- Parameters:
	- tx: Raw Transaction hex (e.g. f869220103a0df8a4d4e54000000000000008805120d17260727768a5355504552434f494e0080801ca0b2f7c98ae6d7eeb1bcf66e6339cb19d402b7ee824890fb65ff998d9ebf279af5a0616a6319a416a47ecb2c36d97b02f1867456f5551d38f76eeb29b70b79bdf0e6)
	- completion: Method which will be called after request finished, contains Tx hash, status text and error if occured
	*/
	public func send(tx: String, completion: ((String?, String?, Error?) -> ())?) {
		
		let url = MinterAPIURL.sendTransaction.url()
		
		self.httpClient.getRequest(url, parameters: ["tx" : tx]) { (response, error) in
			
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
			resultText = (err as? HTTPClientError)?.userData?["message"] as? String
		}
	}
	
	
	/**
	Method retreives buy coin estimate data from a Minter node
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
	Method retreives sell coin estimate data from a Minter node
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
	public func estimateCommission(for rawTx: String, height: String = "0", completion: ( (Decimal?, Error?) -> ())? ) {
		
		let url = MinterAPIURL.estimateTxCommission.url()
		
		let tx = rawTx.stripMinterHexPrefix()
		
		self.httpClient.getRequest(url, parameters: ["tx" : "Mt" + tx, "height" : height]) { (response, error) in
			
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
