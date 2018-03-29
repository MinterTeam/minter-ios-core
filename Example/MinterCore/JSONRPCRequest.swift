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
import web3swift


class JSONRPCRequest : Encodable, ParameterEncoding {
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case params = "params"
		case jsonrpc = "jsonrpc"
		case method = "method"
	}
	
	//MARK: -
	
	var id: String?
	
	var params: JSONRPCRequestParams?
	
	var jsonrpc: String? = "2.0"
	
	var method: String?
	
	//MARK: - Decodable
	
//	public required init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		id = try values.decode(String.self, forKey: .id)
//		params = try values.decode(params, forKey: .params)
//		jsonrpc = try values.decode(String.self, forKey: .jsonrpc)
//		method = try values.decode(String.self, forKey: .method)
//	}
	
	//MARK: - Codable
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(params, forKey: .params)
		try container.encode(jsonrpc, forKey: .jsonrpc)
		try container.encode(method, forKey: .method)
	}
	
	//MARK: -
	
	public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
		let jsonSerialization = try JSONEncoder().encode(self)
		var request = try urlRequest.asURLRequest()
		request.httpBody = jsonSerialization
		return request
	}
	
}

public struct JSONRPCRequestParams : Encodable {
	
	public var params = [Any]()
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()
		
		for par in params {
//			if let p = par as? Encodable {
//				try container.encode(p)
//			} else
			if let p = par as? String {
				try container.encode(p)
			} else if let p = par as? Bool {
				try container.encode(p)
			}
		}
	}
}


public struct MinterTransaction : Encodable {

	public var nonce: BigUInt
	public var gasPrice: BigUInt = BigUInt("5000000000", radix: 10)!
	public var type: BigUInt = BigUInt(1)
	public var data: Data
//	public var from: String
	public var v: BigUInt = BigUInt(1)
	public var r: BigUInt = BigUInt(0)
	public var s: BigUInt = BigUInt(0)

	enum CodingKeys: String, CodingKey {
		case nonce
		case gasPrice
		case type
		case data
//		case from
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
//		try container.encode(from, forKey: .from)
		try container.encode(v, forKey: .v)
		try container.encode(r, forKey: .r)
		try container.encode(s, forKey: .s)
	}
	
	public func encode(forSignature: Bool = false) -> Data? {
		
		if (forSignature) {
			
			let fields = [self.nonce, self.gasPrice, self.type, self.data] as [Any]
			return RLP.encode(fields)
//			return Data(bytes: byteArray)
		}
		else {
			
			let fields = [self.nonce, self.gasPrice, self.type, self.data, self.v, self.r, self.s] as [Any]
			return RLP.encode(fields)
//			return Data(bytes: byteArray)
		}
	}
}

public struct MinterTransactionData : Encodable {
	public var to: String
	public var value: BigUInt
	public var coin = "MINT"
//	public var type = "send"
//	public var from = "d2be6d14b627dd22f964f7d1464d53479078fe7d"
	
	
	enum CodingKeys: String, CodingKey {
		case to
		case value
		case coin
//		case type
//		case from
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(to, forKey: .to)
		try container.encode(value, forKey: .value)
		try container.encode(coin, forKey: .coin)
//		try container.encode(type, forKey: .type)
//		try container.encode(from, forKey: .from)
	}
	
	func encode() -> Data? {
		let dataArray = Array<UInt8>(hex: self.to.lowercased().stripMinterHexPrefix())
		guard let toData = Data(dataArray).setLengthLeft(20) else {
			return Data()
		}
		let fields = [coin, toData, value] as [Any]
		return RLP.encode(fields)
	}
}
