//
//  RawTransactionSigner.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 30/03/2018.
//

import Foundation
import CryptoSwift
import secp256k1
import BigInt


public class RawTransactionSigner {
	
	//throwable?
	public static func sign(rawTx: RawTransaction, privateKey: String) -> String? {
		
		var tx = rawTx
		
		let privateKeyData = Data(hex: privateKey)
		
		let rawTxData = tx.encode(forSignature: true)
		
		guard rawTxData != nil else {
			return nil
		}
		
		let hash = RawTransactionSigner.hashForSigning(data: rawTxData!)
		
		guard hash != nil else {
			return nil
		}
		
		let sign = RawTransactionSigner.sign(hash!, privateKey: privateKeyData)
		guard sign.r != nil && sign.s != nil && sign.v != nil else {
			return nil
		}
		
		tx.r = BigUInt(sign.r!)
		tx.s = BigUInt(sign.s!)
		tx.v = BigUInt(sign.v!)
		
		return tx.encode(forSignature: false)?.toHexString()
	}
	
	private static func hashForSigning(data: Data) -> Data? {
		let sha3 = SHA3(variant: .keccak256)
		let hash = Data(bytes: sha3.calculate(for: data.bytes))
		return hash
	}
	
	private static func sign(_ data: Data, privateKey: Data) -> (r: Data?, s: Data?, v: Data?) {
//		let hash = RawTransactionSigner.hashForSigning(data: data)
//		guard hash != nil else {
//			return (r: nil, s: nil, v: nil)
//		}
		
		let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
		defer { secp256k1_context_destroy(context) }
		
		var signature = secp256k1_ecdsa_recoverable_signature()
		let status = privateKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
			data.withUnsafeBytes { secp256k1_ecdsa_sign_recoverable(context, &signature, $0, key, nil, nil) }
		}
		
		guard status == 1 else {
			return (r: nil, s: nil, v: nil)
		}
		
		var output = Data(count: 65)
		var recid = 0 as Int32
		_ = output.withUnsafeMutableBytes { (output: UnsafeMutablePointer<UInt8>) in
			secp256k1_ecdsa_recoverable_signature_serialize_compact(context, output, &recid, &signature)
		}
		
		return (
			r: output[..<32],
			s: output[32..<64],
			v: Data(bytes: [UInt8(recid) + UInt8(27)])
		)
	}
	
	public static func verify(privateKey: Data) -> Bool {
		var secret = privateKey.bytes
		let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
		defer { secp256k1_context_destroy(context) }
		
		guard secp256k1_ec_seckey_verify(context, &secret) == 1 else {
			return false
		}
		return true
	}
	
	public static func publicKey(privateKey: Data, compressed: Bool = false) -> Data? {
		let bytes = privateKey.bytes
		var publicKeyStructure = secp256k1_pubkey()
		var privateKey = bytes
		guard secp256k1_ec_pubkey_create(
			secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN) | UInt32(SECP256K1_CONTEXT_VERIFY)),
			&publicKeyStructure,
			&privateKey
			) == 1 else {
				return nil
		}
		
		var publicKey: Array<UInt8>
		var outputLength: Int
		
		if !compressed {
			publicKey = Array<UInt8>(repeating: 0x00, count: 65)
			outputLength = Int(65)
		}
		else {
			publicKey = Array<UInt8>(repeating: 0x00, count: 33)
			outputLength = Int(33)
		}
		
		guard secp256k1_ec_pubkey_serialize(
			secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN) | UInt32(SECP256K1_CONTEXT_VERIFY)),
			&publicKey,
			&outputLength,
			&publicKeyStructure,
			(compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED))
			) == 1 else {
				return nil
		}
			return Data(bytes: publicKey)
	}
	
	public static func address(publicKey: Data) -> String? {
		return Data(bytes: SHA3(variant: .keccak256).calculate(for: publicKey.bytes)).suffix(20).toHexString()
	}
	
}
