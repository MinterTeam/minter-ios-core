//
//  CandidateManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 13/08/2018.
//

import Foundation

/// CandidateManager class
public class CandidateManager: BaseManager {

	/// Method retreives candidate’s info by provided public key. It will respond with 404 code if candidate is not found.
	///
	/// - Parameters:
	///   - publicKey: public key with "Mp" prefix
	///   - completion: method which will be called after request finished
	public func candidate(publicKey: String, height: String = "0", completion: (([String : Any]?, Error?) -> ())?) {

		let url = MinterAPIURL.candidate(publicKey: publicKey).url()

		self.httpClient.getRequest(url, parameters: ["height": height]) { (response, err) in

			var res: [String: Any]?
			var error: Error?

			defer {
				completion?(res, error)
			}

			guard nil == err else {
				error = err
				return
			}

			res = (response.data as? [String: Any])
		}
	}

	public func candidates(height: String = "0", includeStakes: Bool = false, completion: (([[String : Any]]?, Error?) -> ())?) {

		let url = MinterAPIURL.candidates.url()

		self.httpClient.getRequest(url, parameters: ["height": height,
																								 //HACK: can't change ParameterEncoding now, TODO: Remove after APIClient cleanup
																								 "include_stakes": includeStakes ? "true" : "false"]) { (response, err) in

			var res: [[String: Any]]?
			var error: Error?

			defer {
				completion?(res, error)
			}

			guard nil == err, let responseData = response.data as? [String: Any] else {
				error = err
				return
			}

			res = responseData["candidates"] as? [[String: Any]]
		}
	}

}
