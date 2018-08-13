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
	
	/// Method retreives amount of base coin (BIP or MNT) existing in the network. It counts block rewards, premine and relayed rewards.
	///
	/// - Parameters:
	///   - height: block height
	///   - completion: methods which will be called after request finished. Completion optionally contains volume (in pips) string and error if occured.
	public func baseCoinVolume(height: Int, completion: ((String?, Error?) -> ())?) {
		
		let url = MinterAPIURL.bipVolume.url()
		
		self.httpClient.getRequest(url, parameters: ["height" : height]) { (response, err) in
			
			var res: String?
			var error: Error?
			
			defer {
				completion?(res, error)
			}
			
			guard nil == err else {
				error = err
				return
			}
			
			res = (response.data as? [String : Any])?["volume"] as? String
			
		}
	}
	
}
