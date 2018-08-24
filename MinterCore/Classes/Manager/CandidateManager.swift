//
//  CandidateManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 13/08/2018.
//

import Foundation


/// CandidateManager class
public class CandidateManager : BaseManager {
	
	
	/// Method retreives candidate’s info by provided public key. It will respond with 404 code if candidate is not found.
	///
	/// - Parameters:
	///   - publicKey: public key with "Mp" prefix
	///   - completion: method which will be called after request finished
	public func candidate(publicKey: String, completion: (([String : Any]?, Error?) -> ())?) {
		
		let url = MinterAPIURL.candidate(publicKey: publicKey).url()
		
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
			
			res = (response.data as? [String : Any])?["candidate"] as? [String : Any]
		}
	}

}