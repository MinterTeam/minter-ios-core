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

/// Raw Transaction Signer class is used to sign, verify etc
public class RawTransactionSigner {

	/**
	Method signs Raw Transaction with privateKey
	- Parameters:
	- rawTx: RawTransaction instance to be signed
	- privateKey: PrivateKey string to be used to sign Tx
	- Precondition: `privateKey` hex string of private key
	- Returns: Signed encoded RawTx hex string, which is ready to be sent to the Minter Network
	*/
	public static func sign(rawTx: RawTransaction, privateKey: String) -> String? {
		let tx = rawTx
		/// First of all we need to convert private key string into Hex Data instance
		let privateKeyData = Data(hex: privateKey)

		/// Encoding raw tx for signature
		let rawTxData = tx.encode(forSignature: true)

		guard rawTxData != nil else {
			return nil
		}

		/// Getting encoded tx signing hash
		let hash = RawTransactionSigner.hashForSigning(data: rawTxData!)

		guard hash != nil else {
			return nil
		}

		/// Signing tx with hash and prepared private key and extracting digital signature
		let sign = RawTransactionSigner.sign(hash!, privateKey: privateKeyData)
		guard sign.r != nil && sign.s != nil && sign.v != nil else {
			return nil
		}

		/// Prepearing Tx to be sent to the Minter Network
		tx.signatureData.r = BigUInt(sign.r!)
		tx.signatureData.s = BigUInt(sign.s!)
		tx.signatureData.v = BigUInt(sign.v!)

		return tx.encode(forSignature: false)?.toHexString()
	}

  public static func sign(rawTx: RawTransaction, address: String, privateKeys: [String]) -> String? {
    guard let txDataToSign = rawTx.encode(forSignature: true) else { return nil }
    let hash = RawTransactionSigner.hashForSigning(data: txDataToSign)!

    let signs = privateKeys.map { (privateKey) -> (v: Data?, r: Data?, s: Data?)? in
      guard let key = Data(hexString: privateKey) else { return nil }
      return self.sign(hash, privateKey: key)
    }.filter { (val) -> Bool in
      return val != nil
    } as? [(v: Data, r: Data, s: Data)] ?? []

    guard !signs.isEmpty else {
      return nil
    }

    rawTx.signatureType = BigUInt(2)
    rawTx.signatureData = .init(multisigAddress: address,
                                signatures: signs)

    return rawTx.encode(forSignature: false)?.toHexString()
  }

	/**
	Method calculates hash from RawTx data
	- Parameters:
	- data: Encoded raw tx data
	- Precondition: `data` is RawTx RLP-encoded Data object
	*/
	public static func hashForSigning(data: Data) -> Data? {
		let sha3 = SHA3(variant: .keccak256)
		let hash = Data(bytes: sha3.calculate(for: data.bytes))
		return hash
	}

	/**
	Method signs Data with privateKey
	- Parameters:
	- data: Data to be signed
	- privateKey: PrivateKey Data object to be used to sign Tx
	- Returns: R S V of signed data
	*/
	public static func sign(_ data: Data, privateKey: Data) -> (r: Data?, s: Data?, v: Data?) {
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

	/**
	Method verifies private key data
	- Parameters:
	- privateKey: PrivateKey Data object to be verified
	- Returns: if the private key verified
	*/
	public static func verify(privateKey: Data) -> Bool {
		var secret = privateKey.bytes
		let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
		defer { secp256k1_context_destroy(context) }

		guard secp256k1_ec_seckey_verify(context, &secret) == 1 else {
			return false
		}
		return true
	}

	/**
	Method retreives public key
	- Parameters:
	- privateKey: PrivateKey Data object
	- compressed: whether public key should be compressed
	- Returns: Public key data
	*/
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
		} else {
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

	public static func seed(from mnemonic: String, passphrase: String = "", language: CKMnemonicLanguageType = .english) -> String? {
		return try? CKMnemonic.deterministicSeedString(from: mnemonic,
																									 passphrase: passphrase,
																									 language: language)
	}

	/**
	Method retreives address
	- Parameters:
	- publicKey: PublicKey Data object
	- Returns: Address string without "Mx" prefix
	*/
	public static func address(publicKey: Data) -> String? {
		return Data(bytes: SHA3(variant: .keccak256).calculate(for: publicKey.bytes)).suffix(20).toHexString()
	}

	public static func address(privateKey: String) -> String? {
		guard let pubKey = RawTransactionSigner.publicKey(privateKey: Data(hex: privateKey), compressed: false)?.dropFirst() else {
			return nil
		}
		return RawTransactionSigner.address(publicKey: pubKey)
	}

	/**
	Method signs Check Data with privateKey
	- Parameters:
	- data: Check Data to be signed
	- privateKey: PrivateKey Data object to be used to sign Tx
	- Returns: R S V of signed check
	*/
	public static func signCheck(_ data: Data, privateKey: Data) -> (r: Data?, s: Data?, v: Data?) {
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

    let r = output[..<32]
    let s = output[32..<64]
    let v = Data(bytes: [UInt8(recid)])

		return (
			r: r,
			s: s,
			v: v
		)
	}

	public static func proof(address: String, passphrase: String) -> Data? {
		let key = passphrase.sha256().dataWithHexString()

		let rlp = RLP.encode([Data(hex: address.stripMinterHexPrefix())])

		guard let addr = rlp?.sha3(.keccak256) else {
			return nil
		}

		let sig = RawTransactionSigner.signCheck(addr, privateKey: key)

		guard nil != sig.r && nil != sig.s && nil != sig.v else {
			return nil
		}

		return sig.r! + sig.s! + sig.v!
	}
}
