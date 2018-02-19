//
//  MinterAPIURL.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import Foundation


let MinterAPIBaseURL = "http://minter-fake-api.dl-dev.ru:8841/api/"


enum MinterAPIURL {
	
	case getBalance
	
	
	
	func url() -> URL {
		switch self {
		case .getBalance:
			return URL(string: MinterAPIBaseURL + "getBalance")!
			
		
			
		}
	}
}
