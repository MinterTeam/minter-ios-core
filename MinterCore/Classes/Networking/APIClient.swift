//
//  APIClient.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import Alamofire

class APIClient {
	
	//MARK: -
	
	public static let shared = APIClient()
	
	private init() {}
	
	//MARK: -
		
	fileprivate static var configuration = URLSessionConfiguration.default {
		didSet {
			let headers = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
			self.configuration.httpAdditionalHeaders = headers
			self.configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		}
	}

	fileprivate static var AlamofireManager: SessionManager = {
		return SessionManager(configuration: configuration)
	}()

	fileprivate class func updatedManager(_ headers: [AnyHashable: Any?]? = nil) -> SessionManager {
		let defaultHeaders = AlamofireManager.session.configuration.httpAdditionalHeaders
		var newHeaders = defaultHeaders ?? [:]
		if headers != nil {
			for (key, value) in headers! {
				if let value = value {
					newHeaders[key] = value
				} else {
					newHeaders.removeValue(forKey: key)
				}
			}
		}
		let configuration = AlamofireManager.session.configuration
		configuration.httpAdditionalHeaders = newHeaders
		return SessionManager(configuration: configuration)
	}

	// MARK: - Alamofire helper function.
	fileprivate func performRequest(_ url: String, parameters: [String: Any]? = nil, method: HTTPMethod = .get, completionHandler: HTTPClient.CompletionBlock?) {
		
		let encodeUsing: ParameterEncoding = JSONEncoding.default//(method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default
		
		APIClient.AlamofireManager.request(url, method: method, parameters: parameters, encoding: encodeUsing).responseJSON { response in
			
		}
	}
}

extension APIClient : HTTPClient {

	// MARK: - Protocol methods
	
	public func postRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?) {
		performRequest(url, parameters: parameters,  method: .post, completionHandler: completionHandler)
	}
	
	public func getRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?) {
		performRequest(url, parameters: parameters,  method: .get, completionHandler: completionHandler)
	}
	
	public func putRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?) {
		performRequest(url, parameters: parameters,  method: .put, completionHandler: completionHandler)
	}
	
	public func deleteRequest(_ url: String, parameters: [String: Any]?, completionHandler: HTTPClient.CompletionBlock?) {
		performRequest(url, parameters: parameters,  method: .delete, completionHandler: completionHandler)
	}
	
}

