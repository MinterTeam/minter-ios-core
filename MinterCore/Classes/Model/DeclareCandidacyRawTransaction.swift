//
//  DeclareCandidacyRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import BigInt
import Foundation

/// DeclareCandidacyRawTransaction
public class DeclareCandidacyRawTransaction: RawTransaction {
    public convenience init(nonce: BigUInt,
                            chainId: Int = MinterCoreSDK.shared.network.rawValue,
                            gasCoin: Data,
                            data: Data)
    {
        self.init(nonce: nonce,
                  chainId: chainId,
                  gasPrice: BigUInt(1),
                  gasCoin: gasCoin,
                  type: RawTransactionType.declareCandidacy.BigUIntValue(),
                  payload: Data(),
                  serviceData: Data())
        self.data = data
    }

    public convenience init(nonce: BigUInt,
                            chainId: Int = MinterCoreSDK.shared.network.rawValue,
                            gasCoin: String,
                            address: String,
                            publicKey: String,
                            commission: BigUInt,
                            coin: String,
                            stake: BigUInt)
    {
        let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)

        let encodedData = DeclareCandidacyRawTransactionData(address: address,
                                                             publicKey: publicKey,
                                                             commission: commission,
                                                             coin: coin,
                                                             stake: stake).encode() ?? Data()
        self.init(nonce: nonce,
                  chainId: chainId,
                  gasCoin: coinData,
                  data: encodedData)
    }
}

/// DeclareCandidacyRawTransactionData
public struct DeclareCandidacyRawTransactionData: Encodable, Decodable {
    /// Address to get reward to
    public var address: String

    /// Validator's public key
    public var publicKey: String

    /// Comission (up to 100%)
    public var commission: BigUInt

    /// Coin you declare (e.g. "MNT")
    public var coin: String

    /// Stake
    public var stake: BigUInt

    // MARK: -

    public init(address: String,
                publicKey: String,
                commission: BigUInt,
                coin: String,
                stake: BigUInt)
    {
        self.address = address
        self.publicKey = publicKey
        self.commission = commission
        self.coin = coin
        self.stake = stake
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decode(String.self, forKey: .address)
        publicKey = try values.decode(String.self, forKey: .publicKey)
        commission = try values.decode(BigUInt.self, forKey: .commission)
        coin = try values.decode(String.self, forKey: .coin)
        stake = try values.decode(BigUInt.self, forKey: .stake)
    }

    // MARK: - Encoding

    enum CodingKeys: String, CodingKey {
        case address
        case publicKey
        case commission
        case coin
        case stake
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try container.encode(publicKey, forKey: .publicKey)
        try container.encode(commission, forKey: .commission)
        try container.encode(coin, forKey: .coin)
        try container.encode(stake, forKey: .stake)
    }

    // MARK: - RLPEncoding

    public func encode() -> Data? {
        let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
        let pub = Data(hex: publicKey.stripMinterHexPrefix())
        let adrs = Data(hex: address.stripMinterHexPrefix())
        let fields = [adrs, pub, commission, coinData, stake] as [Any]
        return RLP.encode(fields)
    }
}
