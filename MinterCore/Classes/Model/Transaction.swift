//
//  Transaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 19/02/2018.
//

import BigInt
import Foundation
import ObjectMapper

public let TransactionCoinFactor = BigUInt(stringLiteral: "1000000000000000000")
public let TransactionCoinFactorDecimal = pow(10, 18)

/// Transaction type
public enum TransactionType: Int {
    case send = 1
    case sell = 2
    case sellAll = 3
    case buy = 4
    case createCoin = 5
    case declare = 6
    case delegate = 7
    case unbond = 8
    case redeemCheck = 9
    case setCandidateOnline = 10
    case setCandidateOffline = 11
    case createMultisig = 12
    case multisend = 13
    case editCandidate = 14
}

/// Transaction Model
open class Transaction {
    public init() {}

    // MARK: -

    public var hash: String?
    public var rawTx: String?
    public var height: Int?
    public var index: Int?
    public var txResult: [String: Any]?
    public var from: String?
    public var nonce: Int?
    public var gasPrice: Int?
    public var type: TransactionType?
    public var data: [String: Any]?
    public var payload: String?
}

class TransactionMappable: Transaction, Mappable {
    // MARK: - Mappable

    required init?(map: Map) {
        super.init()

        mapping(map: map)
    }

    func mapping(map: Map) {
        hash <- map["hash"]
        rawTx <- map["raw_tx"]
        height <- map["height"]
        index <- map["index"]
        txResult <- map["tx_result"]
        from <- map["from"]
        nonce <- map["nonce"]
        gasPrice <- map["gas_price"]
        type <- (map["type"], TransactionTypeTransformer())
        data <- map["data"]
        payload <- map["payload"]
    }
}
