//
//  String+Mnemonic.swift
//  Alamofire
//
//  Created by Alexey Sidorov on 04/05/2018.
//

import CryptoSwift
import Foundation

public extension String {
    static func seedString(_ mnemonic: String, passphrase: String = "") -> String? {
        return try? CKMnemonic.deterministicSeedString(from: mnemonic, passphrase: passphrase, language: .english)
    }

    static func generateMnemonicString() -> String? {
        let language: CKMnemonicLanguageType = .english
        return try? CKMnemonic.generateMnemonic(strength: 128, language: language)
    }
}
