//
//  BaseManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation

public struct BadResponse : Error {
	
}

public class BaseManager {
	
	//MARK: -
	
	var httpClient: HTTPClient
	
	public required init(httpClient: HTTPClient) {
		self.httpClient = httpClient
	}

}
