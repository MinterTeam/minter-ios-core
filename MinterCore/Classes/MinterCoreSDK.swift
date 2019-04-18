//
//  MinterCore.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 04/10/2018.
//

import Foundation

public class MinterCoreSDK {

	public enum Network : Int {
		case mainnet = 1
		case testnet = 2
	}

	private init() {}

	public static let shared = MinterCoreSDK()
	
	public var network: Network {
		return self._network
	}

	/// Node url
	internal var url: URL? = nil
	internal var _network: Network = .testnet

	/// MinterCore SDK initializer
	public class func initialize(urlString: String, network: Network = .testnet) {
		shared.url = URL(string: urlString)
		shared._network = network
	}

}
