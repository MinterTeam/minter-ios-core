//
//  DeepLinkManager.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 21.02.2020.
//

import Foundation

public class DeepLinkManager {
    private var transaction: RawTransaction

    public init(transaction: RawTransaction) {
        self.transaction = transaction
    }

    public func encode() -> URL? {
        let encoded = RLP.encode([transaction.type,
                                  transaction.data,
                                  transaction.payload,
                                  transaction.nonce,
                                  transaction.gasPrice,
                                  transaction.gasCoin])

        guard let encodedTx = encoded?.base64EncodedString() else { return nil }

        let url = URL(string: "https://bip.to/tx/" + encodedTx)
        return url
    }
}
