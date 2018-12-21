//
//  AccountManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


enum AccountManagerError : Error {
	case balanceIncorrectPayload
}

/// Account Manager
public class AccountManager : BaseManager {
	
	/**
		Method retreives balance data from the Minter node
		- Parameters:
			- address: Address for which balance will be retreived
			- completion: Method which will be called after request finished. Balance is in PIPs
		- Precondition: `address` must contain "Mx" prefix
	*/
	public func address(_ address: String, height: String = "0", with completion: (([String : Any]?, Error?) -> ())?) {
		
		let balanceURL = MinterAPIURL.address.url()
		
		self.httpClient.getRequest(balanceURL, parameters: ["address" : address, "height" : height]) { (response, error) in
			
			var res: [String : Any]?
			var err: Error?
			
			defer {
				completion?(res, err)
			}
			
			guard nil == error else {
				err = error
				return
			}
			
			/// trying to parse response
			guard let balance = response.data as? [String : Any] else {
				err = AccountManagerError.balanceIncorrectPayload
				return
			}
			
			res = balance
			
		}
	}

}
