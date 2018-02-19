//
//  HTTPClient.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation

public protocol HTTPClient {
	
	typealias CompletionBlock = ((_ response: DataResponse<Any?>, _ error: Error?) -> Void)
	
	
	func postRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func getRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func putRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
	func deleteRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?)
	
}
