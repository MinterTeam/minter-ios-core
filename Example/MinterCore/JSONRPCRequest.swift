//
//  JSONRPCRequest.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 13/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import BigInt


public struct MinterTransaction : Encodable {

	public var nonce: BigUInt
	public var gasPrice: BigUInt = BigUInt("1000000000", radix: 10)!
	public var type: BigUInt = BigUInt(1)
	public var data: Data
	public var v: BigUInt = BigUInt(1)
	public var r: BigUInt = BigUInt(0)
	public var s: BigUInt = BigUInt(0)

	enum CodingKeys: String, CodingKey {
		case nonce
		case gasPrice
		case type
		case data
		case v
		case r
		case s
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(nonce, forKey: .nonce)
		try container.encode(gasPrice, forKey: .gasPrice)
		try container.encode(type, forKey: .type)
		try container.encode(data, forKey: .data)
		try container.encode(v, forKey: .v)
		try container.encode(r, forKey: .r)
		try container.encode(s, forKey: .s)
	}
	
	public func encode(forSignature: Bool = false) -> Data? {
		
		if (forSignature) {
			
			let fields = [self.nonce, self.gasPrice, self.type, self.data] as [Any]
			return RLP.encode(fields)
		}
		else {
			
			let fields = [self.nonce, self.gasPrice, self.type, self.data, self.v, self.r, self.s] as [Any]
			return RLP.encode(fields)
		}
	}
}

public struct MinterTransactionData : Encodable {
	public var to: String
	public var value: BigUInt
	public var coin = "BIP"
	
	
	enum CodingKeys: String, CodingKey {
		case to
		case value
		case coin
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(to, forKey: .to)
		try container.encode(value, forKey: .value)
		try container.encode(coin, forKey: .coin)
	}
	
	func encode() -> Data? {
		let dataArray = Array<UInt8>(hex: self.to.lowercased().stripMinterHexPrefix())
		guard let toData = Data(dataArray).setLengthLeft(20) else {
			return Data()
		}
		
		let coinData = coin.data(using: .utf8)?.setLengthLeft(10) ?? Data(repeating: 0, count: 10)
		
		let fields = [coinData, toData, value] as [Any]
		return RLP.encode(fields)
	}
}