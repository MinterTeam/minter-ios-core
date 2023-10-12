//
//  SwapPool.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14.06.2021.
//

import Foundation
import BigInt

public class BuySwapPoolRawTransaction: RawTransaction {

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoin: Coin to spend fee from
  ///    - data: Encoded data to be send (Can be obtained by encoding BuyCoinRawTransactionData instance)
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          data: Data) {

    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(gasPrice),
              gasCoinId: gasCoinId,
              type: RawTransactionType.buySwap.BigUIntValue(),
              payload: Data(),
              serviceData: Data())
    self.data = data
  }

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoinId: Coin to spend fee from
  ///   - coins: Coins path
  ///   - value: How much you'd like to buy
  ///   - maximumValueToSell: Maximum value of coins to sell.
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          coins: [Int],
                          valueToBuy: BigUInt,
                          maximumValueToSell: BigUInt) {

    let encodedData = BuySwapPoolRawTransactionData(coins: coins,
                                                    valueToBuy: valueToBuy,
                                                    maximumValueToSell: maximumValueToSell).encode() ?? Data()
    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: gasPrice,
              gasCoinId: gasCoinId,
              data: encodedData)
  }

}

/// BuyCoinRawTransactionData
public struct BuySwapPoolRawTransactionData: Encodable, Decodable {
  /// Coins path
  public var coins: [Int]
  /// Amount
  public var valueToBuy: BigUInt
  /// Maximum value to buy
  public var maximumValueToSell: BigUInt

  // MARK: -

  public init(coins: [Int],
              valueToBuy: BigUInt,
              maximumValueToSell: BigUInt) {
    self.coins = coins
    self.valueToBuy = valueToBuy
    self.maximumValueToSell = maximumValueToSell
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.coins = try values.decode([Int].self, forKey: .coins)
    self.valueToBuy = try values.decode(BigUInt.self, forKey: .valueToBuy)
    self.maximumValueToSell = try values.decode(BigUInt.self, forKey: .maximumValueToSell)
  }

  // MARK: - Encoding

  enum CodingKeys: String, CodingKey {
    case coins
    case valueToBuy
    case maximumValueToSell
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coins, forKey: .coins)
    try container.encode(valueToBuy, forKey: .valueToBuy)
    try container.encode(maximumValueToSell, forKey: .maximumValueToSell)
  }

  public func encode() -> Data? {
    let fields = [coins, valueToBuy, maximumValueToSell] as [Any]
    return RLP.encode(fields)
  }

}


public class SellSwapPoolRawTransaction: RawTransaction {

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoin: Coin to spend fee from
  ///    - data: Encoded data to be send (Can be obtained by encoding BuyCoinRawTransactionData instance)
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          data: Data) {

    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(gasPrice),
              gasCoinId: gasCoinId,
              type: RawTransactionType.sellSwap.BigUIntValue(),
              payload: Data(),
              serviceData: Data())
    self.data = data
  }

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoinId: Coin to spend fee from
  ///   - coins: Coins path
  ///   - value: How much you'd like to buy
  ///   - maximumValueToSell: Maximum value of coins to sell.
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          coins: [Int],
                          valueToSell: BigUInt,
                          minimumValueToBuy: BigUInt) {

    let encodedData = SellSwapPoolRawTransactionData(coins: coins,
                                                     valueToSell: valueToSell,
                                                     minimumValueToBuy: minimumValueToBuy).encode() ?? Data()
    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: gasPrice,
              gasCoinId: gasCoinId,
              data: encodedData)
  }

}

///
public struct SellSwapPoolRawTransactionData: Encodable, Decodable {
  /// Coins path
  public var coins: [Int]
  /// Amount
  public var valueToSell: BigUInt
  
  public var minimumValueToBuy: BigUInt

  // MARK: -

  public init(coins: [Int],
              valueToSell: BigUInt,
              minimumValueToBuy: BigUInt) {
    self.coins = coins
    self.valueToSell = valueToSell
    self.minimumValueToBuy = minimumValueToBuy
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.coins = try values.decode([Int].self, forKey: .coins)
    self.valueToSell = try values.decode(BigUInt.self, forKey: .valueToSell)
    self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
  }

  // MARK: - Encoding

  enum CodingKeys: String, CodingKey {
    case coins
    case valueToSell
    case minimumValueToBuy
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coins, forKey: .coins)
    try container.encode(valueToSell, forKey: .valueToSell)
    try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
  }

  public func encode() -> Data? {
    let fields = [coins, valueToSell, minimumValueToBuy] as [Any]
    return RLP.encode(fields)
  }

}


public class SellAllSwapPoolRawTransaction: RawTransaction {

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoin: Coin to spend fee from
  ///    - data: Encoded data to be send (Can be obtained by encoding BuyCoinRawTransactionData instance)
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          data: Data) {

    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(gasPrice),
              gasCoinId: gasCoinId,
              type: RawTransactionType.sellAllSwap.BigUIntValue(),
              payload: Data(),
              serviceData: Data())
    self.data = data
  }

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoinId: Coin to spend fee from
  ///   - coins: Coins path
  ///   - value: How much you'd like to buy
  ///   - maximumValueToSell: Maximum value of coins to sell.
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          coins: [Int],
                          minimumValueToBuy: BigUInt) {

    let encodedData = SellAllSwapPoolRawTransactionData(coins: coins,
                                                        minimumValueToBuy: minimumValueToBuy).encode() ?? Data()
    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: gasPrice,
              gasCoinId: gasCoinId,
              data: encodedData)
  }

}

///
public struct SellAllSwapPoolRawTransactionData: Encodable, Decodable {
  /// Coins path
  public var coins: [Int]
  
  public var minimumValueToBuy: BigUInt

  // MARK: -

  public init(coins: [Int],
              minimumValueToBuy: BigUInt) {
    self.coins = coins
    self.minimumValueToBuy = minimumValueToBuy
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.coins = try values.decode([Int].self, forKey: .coins)
    self.minimumValueToBuy = try values.decode(BigUInt.self, forKey: .minimumValueToBuy)
  }

  // MARK: - Encoding

  enum CodingKeys: String, CodingKey {
    case coins
    case minimumValueToBuy
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(coins, forKey: .coins)
    try container.encode(minimumValueToBuy, forKey: .minimumValueToBuy)
  }

  public func encode() -> Data? {
    let fields = [coins, minimumValueToBuy] as [Any]
    return RLP.encode(fields)
  }

}
