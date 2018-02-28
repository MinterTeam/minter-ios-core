//
//  HTTPClient.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation


public enum HTTPClientResponseStatusCode : Int {
	case unknown = -1
	case noError = 0
	case coinNotFound = 200
	case insufficientFundsForTransaction = 300
	case nonceTooLow = 400
	case nonceTooHigh = 401
	case incorrenctSignture = 500
	case incorrenctTransactionData = 600
	case unknownError = 900
}

public typealias HTTPClientResponseDictionary = [String : Any]

//public typealias HTTPClientResponse = Any


public protocol HTTPClient {
	
	typealias HTTPClientResponse = (code: HTTPClientResponseStatusCode, result: Any?)
	
	typealias CompletionBlock = ((_ response: HTTPClientResponse, _ error: Error?) -> Void)
	
	
	func postRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)
	
	func getRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)
	
	func putRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)
	
	func deleteRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)
	
}
