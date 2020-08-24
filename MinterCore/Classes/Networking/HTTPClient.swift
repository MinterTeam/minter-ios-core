//
//  HTTPClient.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation

public class HTTPClientError : Error {

	public var code: Int?

	public var message: String?

	public init(code: Int?, message: String?) {
		self.code = code
		self.message = message
	}

	public init() {}

	// MARK: -

	public var userData: [String: Any]?

}

public typealias HTTPClientResponseDictionary = [String : Any]

public protocol HTTPClient {

	typealias HTTPClientResponse = (code: Int, data: Any?,
    meta: [String: Any]?,
    links: [String: Any]?)

	typealias CompletionBlock = ((_ response: HTTPClientResponse, _ error: Error?) -> Void)

	func postRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)

	func getRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)

	func putRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)

	func deleteRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?)

}
