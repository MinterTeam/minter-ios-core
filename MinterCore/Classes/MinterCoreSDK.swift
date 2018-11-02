//
//  MinterCore.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 04/10/2018.
//

import Foundation

public class MinterCoreSDK {
	
	
	private init() {}
	
	public static let shared = MinterCoreSDK()
	
	/// Node url
	internal var url: URL? = nil
	
	/// MinterCore SDK initializer
	public class func initialize(urlString: String) {
		shared.url = URL(string: urlString)
	}
	
}
