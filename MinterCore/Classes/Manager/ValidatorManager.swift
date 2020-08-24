//
//  ValidatorManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 13/08/2018.
//

import Foundation

/// ValidatorManager class
public class ValidatorManager: BaseManager {

	/// Method retreives list of active validators
	///
	/// - Parameter completion: method which will be called after request finished.
	public func validators(height: Int, with completion: (([[String : Any]]?, Error?) -> ())?) {
		
		let url = MinterAPIURL.validators.url()
		
		self.httpClient.getRequest(url, parameters: ["height" : height]) { (response, err) in
			
			var res: [[String : Any]]?
			var error: Error?
			
			defer {
				completion?(res, error)
			}
			
			guard nil == err else {
				error = err
				return
			}
			
			res = response.data as? [[String : Any]]
		}
	}

}
