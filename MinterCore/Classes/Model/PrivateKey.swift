//
//  PrivateKey.swift
//  AEAccordion
//
//  Created by Alexey Sidorov on 05/05/2018.
//

import Foundation
import CryptoSwift


class PrivateKey {
	
//	public let network: Network
	public let depth: UInt8
	public let fingerprint: UInt8
	public let childIndex: UInt8
	
	let raw: Data
	let chainCode: Data
	
	public convenience init(seed: Data) {
		
		let hmac = HMAC(key: "Bitcoin seed".bytes, variant: HMAC.Variant.sha512)
		let val = try! hmac.authenticate(seed.bytes)
		
//		let hmac = Crypto.hmacsha512(data: seed, key: "Bitcoin seed".data(using: .ascii)!)
		let privateKey = val[0..<32]
		let chainCode = val[32..<64]
		self.init(privateKey: Data(bytes: privateKey), chainCode: Data(bytes: chainCode))
	}
	
	init(privateKey: Data, chainCode: Data, depth: UInt8 = 0, fingerprint: UInt8 = 0, childIndex: UInt8 = 0) {
		self.raw = privateKey
		self.chainCode = chainCode
//		self.network = network
		self.depth = depth
		self.fingerprint = fingerprint
		self.childIndex = childIndex
	}
	
	public func extended() -> String {
		var data = [UInt8]()
//		data += UInt32(0x0488ade4).bigEndian//network.xprivkey.bigEndian
		data.append(depth.littleEndian)
		data.append(fingerprint.littleEndian)
		data.append(childIndex.littleEndian)
		data.append(contentsOf: chainCode.bytes)
//		chainCode.bytes.forEach { (byte) in
//			data.append(byte)
//		}
		data.append(UInt8(0))
		data.append(contentsOf: raw)
		let newData = Data(bytes: data)
//		let checksum = Crypto.sha256sha256(data).prefix(4)
//		return Base58.encode(data + checksum)
		return newData.toHexString()
	}
	
//	public func derived(at index: UInt32, hardened: Bool = false) -> PrivateKey {
//		// As we use explicit parameter "hardened", do not allow higher bit set.
//		if (0x80000000 & index) != 0 {
//			fatalError("invalid child index")
//		}
	
//		return PrivateKey(privateKey: <#T##Data#>, chainCode: <#T##Data#>)
		
//		guard let derivedKey = _HDKey(privateKey: raw, publicKey: publicKey().raw, chainCode: chainCode, depth: depth, fingerprint: fingerprint, childIndex: childIndex).derived(at: index, hardened: hardened) else {
//			throw DerivationError.derivateionFailed
//		}
//		return HDPrivateKey(privateKey: derivedKey.privateKey!, chainCode: derivedKey.chainCode, network: network, depth: derivedKey.depth, fingerprint: derivedKey.fingerprint, childIndex: derivedKey.childIndex)
//	}
	
}

