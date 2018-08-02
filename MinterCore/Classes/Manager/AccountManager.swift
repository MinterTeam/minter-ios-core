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
			- address: Address for which balance should be retreived
			- completion: Method which will be called after request finished
		- Precondition: `address` should contain "Mx" prefix
	*/
	public func balance(address: String, with completion: (([String : Any]?, Error?) -> ())?) {
		
		let balanceURL = MinterAPIURL.balance(address: address).url()
		
		self.httpClient.getRequest(balanceURL, parameters: nil) { (response, error) in
			
			var res: [String : Any]?
			var err: Error?
			
			defer {
				completion?(res, err)
			}
			
			guard nil == error else {
				err = error
				return
			}
			
			guard let balance = response.data as? [String : Any] else {
				err = AccountManagerError.balanceIncorrectPayload
				return
			}
			
			res = balance
			
		}
	}

}
