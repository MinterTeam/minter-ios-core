//
//  PrivateKey.swift
//  AEAccordion
//
//  Created by Alexey Sidorov on 05/05/2018.
//

import Foundation
import CryptoSwift


public class PrivateKey {
	
//	public let network: Network
	public let depth: UInt8
	public let fingerprint: UInt8
	public let childIndex: UInt8
	
	let raw: Data
	let chainCode: Data
	
	let publicKey: Data
	
	public convenience init(seed: Data) {
		
		let hmac = HMAC(key: "Bitcoin seed".data(using: .ascii)!.bytes, variant: HMAC.Variant.sha512)
		let val = try! hmac.authenticate(seed.bytes)
		
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
		
		self.publicKey = RawTransactionSigner.publicKey(privateKey: privateKey)!

	}
	
//	public func extended1() -> String {
//
//
//		var privkey = 0x0488ade4.bigEndian
//		let privkeyData = NSData(bytes: &privkey, length: MemoryLayout<Int>.size) as! Data
//
//		var data = [UInt8]()
//		data.append(contentsOf: privkeyData.bytes)
//		data.append(depth.littleEndian)
//		data.append(fingerprint.littleEndian)
//		data.append(childIndex.littleEndian)
//		data.append(contentsOf: chainCode.bytes)
//		data.append(UInt8(0))
//		data.append(contentsOf: raw)
//		let newData = Data(bytes: data)
//		let checksum = newData.sha256().sha256().prefix(4)//Crypto.sha256sha256(data).prefix(4)
////		return Base58.encode(data + checksum)
//		return Base58.base58FromBytes(newData + checksum.bytes)
//	}
	
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
	
	public func derive(at index: UInt32, hardened: Bool) {
		var data = Data()
		var isHardened = index >= 0x80000000
		
		if hardened {
			let padding = UInt8(0)
			data.append(padding)
			data.append(self.raw)
		}
		else {
			data.append(self.publicKey)
		}
		
		let childIndex = index
		
		
//			BN_CTX *ctx = BN_CTX_new();
//
//			NSMutableData *data = [NSMutableData data];
//			if (hardened) {
//				uint8_t padding = 0;
//				[data appendBytes:&padding length:1];
//				[data appendData:self.privateKey];
//			} else {
//				[data appendData:self.publicKey];
//			}
//
//			uint32_t childIndex = OSSwapHostToBigInt32(hardened ? (0x80000000 | index) : index);
//			[data appendBytes:&childIndex length:sizeof(childIndex)];
//
//			NSData *digest = [CryptoHash hmacsha512:data key:self.chainCode];
//			NSData *derivedPrivateKey = [digest subdataWithRange:NSMakeRange(0, 32)];
//			NSData *derivedChainCode = [digest subdataWithRange:NSMakeRange(32, 32)];
//
//			BIGNUM *curveOrder = BN_new();
//			BN_hex2bn(&curveOrder, "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141");
//
//			BIGNUM *factor = BN_new();
//			BN_bin2bn(derivedPrivateKey.bytes, (int)derivedPrivateKey.length, factor);
//			// Factor is too big, this derivation is invalid.
//			if (BN_cmp(factor, curveOrder) >= 0) {
//				return nil;
//			}
//
//			NSMutableData *result;
//			if (self.privateKey) {
//				BIGNUM *privateKey = BN_new();
//				BN_bin2bn(self.privateKey.bytes, (int)self.privateKey.length, privateKey);
//
//				BN_mod_add(privateKey, privateKey, factor, curveOrder, ctx);
//				// Check for invalid derivation.
//				if (BN_is_zero(privateKey)) {
//					return nil;
//				}
//
//				int numBytes = BN_num_bytes(privateKey);
//				result = [NSMutableData dataWithLength:numBytes];
//				BN_bn2bin(privateKey, result.mutableBytes);
//
//				BN_free(privateKey);
//			} else {
//				BIGNUM *publicKey = BN_new();
//				BN_bin2bn(self.publicKey.bytes, (int)self.publicKey.length, publicKey);
//				EC_GROUP *group = EC_GROUP_new_by_curve_name(NID_secp256k1);
//
//				EC_POINT *point = EC_POINT_new(group);
//				EC_POINT_bn2point(group, publicKey, point, ctx);
//				EC_POINT_mul(group, point, factor, point, BN_value_one(), ctx);
//				// Check for invalid derivation.
//				if (EC_POINT_is_at_infinity(group, point) == 1) {
//					return nil;
//				}
//
//				BIGNUM *n = BN_new();
//				result = [NSMutableData dataWithLength:33];
//
//				EC_POINT_point2bn(group, point, POINT_CONVERSION_COMPRESSED, n, ctx);
//				BN_bn2bin(n, result.mutableBytes);
//
//				BN_free(n);
//				BN_free(publicKey);
//				EC_POINT_free(point);
//				EC_GROUP_free(group);
//			}
//
//			BN_free(factor);
//			BN_free(curveOrder);
//			BN_CTX_free(ctx);
//
//			uint32_t *fingerPrint = (uint32_t *)[CryptoHash sha256ripemd160:self.publicKey].bytes;
//			return [[KeyDerivation alloc] initWithPrivateKey:result publicKey:result chainCode:derivedChainCode depth:self.depth + 1 fingerprint:*fingerPrint childIndex:childIndex];
	}
	
}


public struct PublicKey {
	public let raw: Data
	public let chainCode: Data
	private let depth: UInt8
	private let fingerprint: UInt32
	private let childIndex: UInt32
//	private let network: Network
	
	private let hdPrivateKey: PrivateKey
	
	public init(hdPrivateKey: PrivateKey, chainCode: Data, depth: UInt8, fingerprint: UInt32, childIndex: UInt32) {
		self.raw = RawTransactionSigner.publicKey(privateKey: hdPrivateKey.raw)!
		self.chainCode = chainCode
		self.depth = depth
		self.fingerprint = fingerprint
		self.childIndex = childIndex
//		self.network = network
		self.hdPrivateKey = hdPrivateKey
	}
	
	public func extended() -> String {
		var extendedPublicKeyData = Data()
		extendedPublicKeyData += UInt32(0x0488b21e).bigEndian
		extendedPublicKeyData += depth.littleEndian
		extendedPublicKeyData += fingerprint.littleEndian
		extendedPublicKeyData += childIndex.littleEndian
		extendedPublicKeyData += chainCode
		extendedPublicKeyData += raw
		let checksum = extendedPublicKeyData.sha256().sha256().prefix(4)
		return Base58.base58FromBytes(extendedPublicKeyData.bytes + checksum.bytes)
	}
}

