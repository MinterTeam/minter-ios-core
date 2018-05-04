//
//  BIP39+String.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 04/05/2018.
//

import Foundation
import CKMnemonic

extension String {
	
	static func seedString(_ mnemonic: String, passphrase: String = "", language: CKMnemonicLanguageType = .english) -> String? {
		return try? CKMnemonic.deterministicSeedString(from: mnemonic, passphrase: passphrase, language: language)
	}
	
	static func generateMnemonicString(_ language: CKMnemonicLanguageType = .english) -> String? {
		let language: CKMnemonicLanguageType = .english
		return try? CKMnemonic.generateMnemonic(strength: 128, language: language)
	}
	
}
