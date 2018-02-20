//
//  HTTPClient.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation

enum HTTPClientResponseStatusCode : Int {
	case noError = 0
	case coinNotFound = 200
	case insufficientFundsForTransaction = 300
	case nonceTooLow = 400
	case nonceTooHigh = 401
	case incorrenctSignture = 500
	case incorrenctTransactionData = 600
	case unknownError = 900
}

typealias HTTPClientResponseDictionary = [String : Any]


public protocol HTTPClient {
	
	typealias HTTPClientResponse = (code: HTTPClientResponseStatusCode, result: HTTPClientResponseDictionary?)
	
	typealias CompletionBlock = ((_ response: HTTPClientResponse, _ error: Error?) -> Void)
	
	
	func postRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func getRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func putRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func deleteRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
}
