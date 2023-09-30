//
//  Session.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 12/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import MinterCore

class Session {
    static let shared = Session()

    private init() {}

    // MARK: -

    func regenMnemonic() {
        mnemonicString = String.generateMnemonicString()!
    }

    var mnemonicString = String.generateMnemonicString()!

    var privateKey: PrivateKey? {
        guard let seed = RawTransactionSigner.seed(from: mnemonicString) else {
            fatalError("Should contain seed")
        }

        let privateKey = PrivateKey(seed: Data(hex: seed))
        let key = try? privateKey
            .derive(at: 44, hardened: true)
            .derive(at: 60, hardened: true)
            .derive(at: 0, hardened: true)
            .derive(at: 0)
            .derive(at: 0)
        return key
    }

    var address: String {
        let publicKey = RawTransactionSigner.publicKey(privateKey: privateKey!.raw, compressed: false)!.dropFirst()
        let address = RawTransactionSigner.address(publicKey: publicKey)
        return "Mx" + address!
    }
}
