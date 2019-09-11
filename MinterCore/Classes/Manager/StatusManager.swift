//
//  StatusManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 13/08/2018.
//

import Foundation

/// StatusManager class
public class StatusManager : BaseManager {
	
	/// Methods return data which shows current state of the node. You also can use it to check if node is running in normal mode.
	/// - Parameter completion: methods which will be called after request finished. Completion optionally contains response data and error if occured.
	public func status(with completion: (([String : Any]?, Error?) -> ())?) {
		
		let url = MinterAPIURL.status.url()
		
		self.httpClient.getRequest(url, parameters: nil) { (response, err) in
			
			var res: [String : Any]?
			var error: Error?
			
			defer {
				completion?(res, error)
			}
			
			guard nil == err else {
				error = err
				return
			}
			
			res = response.data as? [String : Any]
			
		}
	}
	
}
