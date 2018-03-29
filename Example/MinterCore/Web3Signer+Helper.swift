//
//  Web3Signer.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 13/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import web3swift
import BigInt

public extension Web3Signer {
	
	public static func signTX(transaction: inout EthereumTransaction, privateKey: Data) throws {
		
		if (transaction.intrinsicChainID != nil) {
			try EIP155Signer2.sign(transaction: &transaction, privateKey: privateKey)
		} else {
			try FallbackSigner2.sign(transaction: &transaction, privateKey: privateKey)
		}
	}
	
	public struct EIP155Signer2 {
		public static func sign(transaction:inout EthereumTransaction, privateKey: Data) throws {
			for _ in 0..<1024 {
				let result = self.attemptSignature(transaction: &transaction, privateKey: privateKey)
				if (result) {
					return
				}
			}
			throw AbstractKeystoreError.invalidAccountError
		}
		
		private static func attemptSignature(transaction:inout EthereumTransaction, privateKey: Data) -> Bool {
			guard let chainID = transaction.intrinsicChainID else {return false}
			guard let hash = transaction.hashForSignature(chainID: chainID) else {return false}
			let signature  = SECP256K1_2.signForRecovery(hash: hash, privateKey: privateKey)
			guard let compressedSignature = signature.compressed else {return false}
			guard let unmarshalledSignature = SECP256K1_2.unmarshalSignature(signatureData: compressedSignature) else {
				return false
			}
			let originalPublicKey = SECP256K1_2.privateToPublic(privateKey: privateKey)
			transaction.v = BigUInt(unmarshalledSignature.v) + BigUInt(35) + chainID + chainID
			transaction.r = BigUInt(Data(unmarshalledSignature.r))
			transaction.s = BigUInt(Data(unmarshalledSignature.s))
			let recoveredPublicKey = transaction.recoverPublicKey()
			if (!(originalPublicKey!.constantTimeComparisonTo(recoveredPublicKey))) {
				return false
			}
			return true
		}
	}
	
	public struct FallbackSigner2 {
		public static func sign(transaction:inout EthereumTransaction, privateKey: Data) throws {
			for _ in 0..<1024 {
				let result = self.attemptSignature(transaction: &transaction, privateKey: privateKey)
				if (result) {
					return
				}
			}
			throw AbstractKeystoreError.invalidAccountError
		}
		
		private static func attemptSignature(transaction:inout EthereumTransaction, privateKey: Data) -> Bool {
			guard let hash = transaction.hashForSignature(chainID: nil) else {return false}
			let signature  = SECP256K1_2.signForRecovery(hash: hash, privateKey: privateKey)
			guard let compressedSignature = signature.compressed else {return false}
			guard let unmarshalledSignature = SECP256K1_2.unmarshalSignature(signatureData: compressedSignature) else {
				return false
			}
			let originalPublicKey = SECP256K1_2.privateToPublic(privateKey: privateKey)
			transaction.UNSAFE_setChainID(nil)
			transaction.v = BigUInt(unmarshalledSignature.v) + BigUInt(27)
			transaction.r = BigUInt(Data(unmarshalledSignature.r))
			transaction.s = BigUInt(Data(unmarshalledSignature.s))
			let recoveredPublicKey = transaction.recoverPublicKey()
			if (!(originalPublicKey!.constantTimeComparisonTo(recoveredPublicKey))) {
				return false
			}
			return true
		}
	}
	
}


extension String {
	
	func stripMinterHexPrefix() -> String {
		if self.hasPrefix("Mx") || self.hasPrefix("mx") {
			let indexStart = self.index(self.startIndex, offsetBy: 2)
			return String(self[indexStart...])
		}
		return self
	}
}

