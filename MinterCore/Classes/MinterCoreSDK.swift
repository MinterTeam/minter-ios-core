//
//  MinterCore.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 04/10/2018.
//

import Foundation

public class MinterCoreSDK {

	public enum Network {
		case mainnet
		case testnet
	}

	private init() {}

	public static let shared = MinterCoreSDK()

	/// Node url
	internal var url: URL? = nil
	internal var network: Network = .testnet

	/// MinterCore SDK initializer
	public class func initialize(urlString: String, network: Network = .testnet) {
		shared.url = URL(string: urlString)
		shared.network = network
	}

}
