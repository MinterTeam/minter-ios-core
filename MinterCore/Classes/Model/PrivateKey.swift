//
//  PrivateKey.swift
//  AEAccordion
//
//  Created by Alexey Sidorov on 05/05/2018.
//

import Foundation
import CryptoSwift


public class PrivateKey {
	
	public let depth: UInt8
	public let fingerprint: UInt32
	public let childIndex: UInt32
	
	public let raw: Data
	let chainCode: Data
	
	public let publicKey: Data
	
	public convenience init(seed: Data) {
		
		let hmac = HMAC(key: "Bitcoin seed".data(using: .ascii)!.bytes, variant: HMAC.Variant.sha512)
		let val = try! hmac.authenticate(seed.bytes)
		
		let privateKey = val[0..<32]
		let chainCode = val[32..<64]
		self.init(privateKey: Data(bytes: privateKey), chainCode: Data(bytes: chainCode))
	}
	
	init(privateKey: Data, chainCode: Data, depth: UInt8 = 0, fingerprint: UInt32 = 0, childIndex: UInt32 = 0) {
		self.raw = privateKey
		self.chainCode = chainCode
		self.depth = depth
		self.fingerprint = fingerprint
		self.childIndex = childIndex
		
		self.publicKey = RawTransactionSigner.publicKey(privateKey: privateKey, compressed: true)!

	}
	
	public func extended() -> String {
		
		var extendedPrivateKeyData = Data()
		extendedPrivateKeyData += UInt32(0x0488ADE4).bigEndian
		extendedPrivateKeyData += depth.littleEndian
		extendedPrivateKeyData += fingerprint.littleEndian
		extendedPrivateKeyData += childIndex.littleEndian
		extendedPrivateKeyData += chainCode
		extendedPrivateKeyData += UInt8(0)
		extendedPrivateKeyData += raw
		
		let checksum = extendedPrivateKeyData.sha256().sha256().prefix(4)
		
		extendedPrivateKeyData.append(contentsOf: checksum.bytes)
		
		return Base58.base58FromBytes(extendedPrivateKeyData.bytes)
	}
	
	public func derive(at index: UInt32, hardened: Bool = false) -> PrivateKey {
		
		guard (0x80000000 & index) == 0 else {
			fatalError("Invalid index \(index)")
		}
		
		let pubKey = self.publicKey
		
		var data = Data()
		
		if hardened {
			let padding = UInt8(0)
			data.append(padding)
			data.append(self.raw)
		}
		else {
			data.append(self.publicKey)
		}
		
		let childIndex = (hardened ? (0x80000000 | index) : index).bigEndian
		data += childIndex
		
		let hmac = HMAC(key: chainCode.bytes, variant: HMAC.Variant.sha512)
		let digest = try! hmac.authenticate(data.bytes)
		
		let pk = digest[0..<32]
		let chain = digest[32..<64]
		
		let helper = SECP256k1Helper()
		helper.setPrivateKey(privateKey: self.raw)
		
		do {
			try helper.privateKeyTweakAdd(tweak: Data(bytes: Array(pk)))
		} catch {
			return self.derive(at: index + 1, hardened: hardened)
		}
		let hash = Array(RIPEMD160.hash(message: pubKey.sha256()).bytes.prefix(4))
		let fingerprint = UInt32(bytes: hash, fromIndex: 0)
		
		return PrivateKey(privateKey: self.raw, chainCode: Data(bytes: chain), depth: self.depth, fingerprint: fingerprint, childIndex: UInt32(childIndex))
	}

}
