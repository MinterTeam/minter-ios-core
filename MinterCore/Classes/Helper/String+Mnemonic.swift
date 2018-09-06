//
//  String+Mnemonic.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 04/05/2018.
//

import Foundation
import CryptoSwift

public extension String {
	
	public static func seedString(_ mnemonic: String, passphrase: String = "", language: CKMnemonicLanguageType = .english) -> String? {
		return try? CKMnemonic.deterministicSeedString(from: mnemonic, passphrase: passphrase, language: language)
	}
	
	public static func generateMnemonicString(_ language: CKMnemonicLanguageType = .english) -> String? {
		let language: CKMnemonicLanguageType = .english
		return try? CKMnemonic.generateMnemonic(strength: 128, language: language)
	}
	
//	public static func privateKeyString(seed: String) -> String? {
//		let hmac = HMAC(key: "Bitcoin seed".bytes, variant: HMAC.Variant.sha512)
//		let val = try? hmac.authenticate(seed.bytes)
//
//		guard val != nil else {
//			return nil
//		}
//
//		let privateKeyData = Data(bytes: val![0..<32])
//
//		guard RawTransactionSigner.verify(privateKey: privateKeyData) else {
//			return nil
//		}
//
//		return privateKeyData.toHexString()
//	}

}
