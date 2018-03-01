//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation


public extension AccountManager {
	
	class var `default`: AccountManager {
		get {
			let httpClient = APIClient.shared
			let manager = self.init(httpClient: httpClient)
			return manager
		}
	}
}

public extension TransactionManager {
	
	class var `default`: TransactionManager {
		get {
			let httpClient = APIClient.shared
			let manager = self.init(httpClient: httpClient)
			return manager
		}
	}
}

public extension CoinManager {
	
	class var `default`: CoinManager {
		get {
			let httpClient = APIClient.shared
			let manager = self.init(httpClient: httpClient)
			return manager
		}
	}
}
