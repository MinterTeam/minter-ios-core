//
//  APIClient.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation
import Alamofire

let APIClientDefaultHeaders: [String : String] = ["X-Minter-Chain-Id" : "odin"]

/// APIClient
public class APIClient {

	// MARK: -

	private convenience init() {
		self.init(headers: APIClientDefaultHeaders)
	}

	public static let shared = APIClient(headers: APIClientDefaultHeaders)

	public init(headers: [String : String]? = nil) {
		if nil != headers {
			alamofireManager = APIClient.updatedManager(headers!)
		}
	}

	// MARK: -

	fileprivate static var configuration = URLSessionConfiguration.default {
		didSet {
			let headers = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
			self.configuration.httpAdditionalHeaders = headers
			self.configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		}
	}

	fileprivate var alamofireManager: SessionManager = SessionManager(configuration: configuration)

	fileprivate class func updatedManager(_ headers: [AnyHashable: Any?]? = nil) -> SessionManager {
		let defaultManager = SessionManager(configuration: APIClient.configuration)
		var defaultHeaders = defaultManager.session.configuration.httpAdditionalHeaders
		var newHeaders = defaultHeaders ?? [:]

		APIClientDefaultHeaders.forEach({ (k, v) in
			newHeaders[k] = v
		})

		if headers != nil {
			for (key, value) in headers! {
				if let value = value {
					newHeaders[key] = value
				} else {
					newHeaders.removeValue(forKey: key)
				}
			}
		}

		let configuration = defaultManager.session.configuration
		configuration.httpAdditionalHeaders = newHeaders
		return SessionManager(configuration: configuration)
	}

	// MARK: - Alamofire helper function.

	fileprivate func performRequest(_ URL: URL,
																	parameters: [String: Any]? = nil,
																	method: HTTPMethod = .get,
																	completion: HTTPClient.CompletionBlock?) {

		let encodeUsing: ParameterEncoding = (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default
		let manager = alamofireManager
		manager.request(URL, method: method, parameters: parameters, encoding: encodeUsing).responseJSON { response in
			var error: Error?
			var resp = HTTPClient.HTTPClientResponse(response.response?.statusCode ?? -1, [:], [:], [:])

			defer {
				completion?(resp, error)
			}

			error = response.error

			guard let result = response.result.value as? [String : Any] else {
				return
			}

			if let err = result["error"] as? [String: Any] {
        //Some old format?
				if let code = result["code"] as? Int,
           let errorMessage = result["log"] as? String {
					let apiError = HTTPClientError()
					apiError.userData = ["code": code, "message": errorMessage]
					error = apiError
				} else {
          let apiError = HTTPClientError()
          if let code = result["code"] as? String, let codeInt = Int(code) {
            apiError.code = codeInt
          }
          if let message = result["message"] as? String {
            apiError.message = message
          }
					apiError.userData = err
					error = apiError
				}
			} else if let code = result["code"] as? Int, let errorMessage = result["log"] as? String {
				let apiError = HTTPClientError()
				apiError.userData = ["code": code, "message": errorMessage]
				error = apiError
			}

			let meta = result["meta"] as? [String: Any]
			let links = result["links"] as? [String: Any]

			var data: Any?

			if let respData = result["data"] {
				data = respData
			} else if let respData = result["result"] {
				data = respData
      } else {
        data = result
      }

			resp = HTTPClient.HTTPClientResponse(response.response?.statusCode ?? -1, data, meta, links)
		}
	}
}

extension APIClient: HTTPClient {

	// MARK: - Protocol methods

	public func postRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
		performRequest(URL, parameters: parameters,  method: .post, completion: completion)
	}

	public func getRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
		performRequest(URL, parameters: parameters,  method: .get, completion: completion)
	}

	public func putRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
		performRequest(URL, parameters: parameters,  method: .put, completion: completion)
	}

	public func deleteRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
		performRequest(URL, parameters: parameters,  method: .delete, completion: completion)
	}

}

/// NodeAPIClient
public class NodeAPIClient {

  // MARK: -

  private convenience init() {
    self.init(headers: APIClientDefaultHeaders)
  }

  public static let shared = NodeAPIClient(headers: APIClientDefaultHeaders)

  public init(headers: [String : String]? = nil) {
    if nil != headers {
      alamofireManager = NodeAPIClient.updatedManager(headers!)
    }
  }

  // MARK: -

  fileprivate static var configuration = URLSessionConfiguration.default {
    didSet {
      let headers = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
      self.configuration.httpAdditionalHeaders = headers
      self.configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    }
  }

  fileprivate var alamofireManager: SessionManager = SessionManager(configuration: configuration)

  fileprivate class func updatedManager(_ headers: [AnyHashable: Any?]? = nil) -> SessionManager {
    let defaultManager = SessionManager(configuration: APIClient.configuration)
    var defaultHeaders = defaultManager.session.configuration.httpAdditionalHeaders
    var newHeaders = defaultHeaders ?? [:]

    APIClientDefaultHeaders.forEach({ (k, v) in
      newHeaders[k] = v
    })

    if headers != nil {
      for (key, value) in headers! {
        if let value = value {
          newHeaders[key] = value
        } else {
          newHeaders.removeValue(forKey: key)
        }
      }
    }

    let configuration = defaultManager.session.configuration
    configuration.httpAdditionalHeaders = newHeaders
    return SessionManager(configuration: configuration)
  }

  // MARK: - Alamofire helper function.

  fileprivate func performRequest(_ URL: URL,
                                  parameters: [String: Any]? = nil,
                                  method: HTTPMethod = .get,
                                  completion: HTTPClient.CompletionBlock?) {

    let encodeUsing: ParameterEncoding = (method == .post || method == .put) ? JSONEncoding.default : URLEncoding.default
    let manager = alamofireManager
    manager.request(URL, method: method, parameters: parameters, encoding: encodeUsing).responseJSON { response in
      var error: Error?
      var resp = HTTPClient.HTTPClientResponse(response.response?.statusCode ?? -1, [:], [:], [:])

      defer {
        completion?(resp, error)
      }

      error = response.error

      guard let result = response.result.value as? [String: Any] else {
        return
      }

      var data = [String: Any]()

      if response.response?.statusCode != 200 {
        let apiError = HTTPClientError()
        let code = result["code"] ?? -1
        let message = result["message"] ?? ""
        let details = result["details"] ?? ""
        apiError.userData = ["code": code, "message": message, "details": details]
        error = apiError
        data = result
      } else {
        data = result
      }

      resp = HTTPClient.HTTPClientResponse(response.response?.statusCode ?? -1, data, [:], [:])
    }
  }
}

extension NodeAPIClient: HTTPClient {

  // MARK: - Protocol methods

  public func postRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
    performRequest(URL, parameters: parameters,  method: .post, completion: completion)
  }

  public func getRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
    performRequest(URL, parameters: parameters,  method: .get, completion: completion)
  }

  public func putRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
    performRequest(URL, parameters: parameters,  method: .put, completion: completion)
  }

  public func deleteRequest(_ URL: URL, parameters: [String: Any]?, completion: HTTPClient.CompletionBlock?) {
    performRequest(URL, parameters: parameters,  method: .delete, completion: completion)
  }

}
