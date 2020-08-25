//
//  SetHaltBlockRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 24.08.2020.
//

import Foundation
import Foundation
import BigInt

public class SetHaltBlockRawTransaction: RawTransaction {

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoinId: Coin to spend fee from
  ///   - publicKey: Public Key
  ///   - height: Height to set halt block
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasCoinId: Int,
                          publicKey: String,
                          height: UInt) throws {

    guard let data = SetHaltBlockRawTransactionData(publicKey: publicKey, height: height).encode() else {
      throw RawTransactionError.invalidTransactionData
    }
    self.init(nonce: nonce, gasCoinId: gasCoinId, type: RawTransactionType.setHaltBlock.BigUIntValue(), data: data)
  }
}

public class SetHaltBlockRawTransactionData: Encodable, Decodable {

  // MARK: - Props

  /// Public key
  public var publicKey: String

  /// height
  public var height: UInt

  init(publicKey: String, height: UInt) {
    self.publicKey = publicKey
    self.height = height
  }

  required public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.publicKey = try values.decode(String.self, forKey: .publicKey)
    self.height = try values.decode(UInt.self, forKey: .height)
  }

  // MARK: - Encoding

  enum CodingKeys: String, CodingKey {
    case publicKey
    case height
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(publicKey, forKey: .publicKey)
    try container.encode(height, forKey: .height)
  }

  // MARK: - RLP Encoding

  public func encode() -> Data? {
    let fields = [publicKey, height] as [Any]
    return RLP.encode(fields)
  }
}
