//
//  UnbondRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 14/09/2018.
//

import Foundation
import BigInt

/// UnbondRawTransaction
public class UnbondRawTransaction: RawTransaction {

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - chainId - chain identifier
  ///   - gasPrice - gas price
  ///   - gasCoinId: Coin to spend fee from
  ///   - data: Encoded UnbondRawTransactionData instance
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          data: Data) {

    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(gasPrice),
              gasCoinId: gasCoinId,
              type: RawTransactionType.unbond.BigUIntValue(),
              payload: Data(),
              serviceData: Data())
    self.data = data
  }

  /// Convenience initializer
  ///
  /// - Parameters:
  ///   - nonce: Nonce
  ///   - gasCoinId: Coin to spend fee from
  ///   - publicKey: Validator's public key
  ///   - coinId: Coin which you'd like to delegate
  ///   - value: How much you'd like to delegate
  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int,
                          publicKey: String,
                          coinId: Int,
                          value: BigUInt) {
    let encodedData = UnbondRawTransactionData(publicKey: publicKey,
                                               coinId: coinId,
                                               value: value).encode() ?? Data()
    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: gasPrice,
              gasCoinId: gasCoinId,
              data: encodedData)
  }

}

/// UnbondRawTransactionData
public struct UnbondRawTransactionData: Encodable, Decodable {

	/// Validator's public key
	public var publicKey: String

	/// Coin you unbond (e.g. 0)
	public var coinId: Int

	/// Amount to unbond
	public var value: BigUInt

	// MARK: -

	public init(publicKey: String, coinId: Int, value: BigUInt) {
		self.publicKey = publicKey
		self.coinId = coinId
		self.value = value
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.publicKey = try values.decode(String.self, forKey: .publicKey)
		self.coinId = try values.decode(Int.self, forKey: .coinId)
		self.value = try values.decode(BigUInt.self, forKey: .value)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case publicKey
		case coinId
		case value
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(publicKey, forKey: .publicKey)
		try container.encode(coinId, forKey: .coinId)
		try container.encode(value, forKey: .value)
	}

	// MARK: - RLPEncoding

	public func encode() -> Data? {
		let fields = [Data(hex: publicKey.stripMinterHexPrefix()), coinId, value] as [Any]
		return RLP.encode(fields)
	}

}
