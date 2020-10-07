//
//  SendCoinRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 29/05/2018.
//

import Foundation
import BigInt

/// `SendCoinRawTransaction` is a transaction for sending arbitrary coin.
/// - SeeAlso: https://docs.minter.network/#section/Transactions/Send-transaction
public class SendCoinRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
                          gasCoinId: Int = Coin.baseCoin().id!,
													data: Data,
                          signatureType: BigUInt = BigUInt(1)) {
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(gasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.sendCoin.BigUIntValue(),
							payload: Data(),
							serviceData: Data(),
              signatureType: signatureType)
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(gasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.sendCoin.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: Int = RawTransactionDefaultGasPrice,
													gasCoinId: Int = Coin.baseCoin().id!,
													to: String,
													value: BigUInt,
													coinId: Int) {
		let encodedData = SendCoinRawTransactionData(to: to, value: value, coinId: coinId).encode() ?? Data()
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: gasPrice,
							gasCoinId: gasCoinId,
							data: encodedData)
	}

}

/// SendCoinRawTransactionData
public struct SendCoinRawTransactionData: Encodable, Decodable {

	/// Address to whom you'd like to send coins
	public var to: String
	/// How many coins you'd like to send, the value should be in pip
	public var value: BigUInt
	/// Coin symbol (e.g. 1)
	public var coinId: Int = Coin.baseCoin().id!

	// MARK: -

	public init(to: String, value: BigUInt, coinId: Int) {
		self.to = to
		self.value = value
		self.coinId = coinId
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.to = try values.decode(String.self, forKey: .to)
		self.value = try values.decode(BigUInt.self, forKey: .value)
		self.coinId = try values.decode(Int.self, forKey: .coinId)
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case to
		case value
		case coinId
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(to, forKey: .to)
		try container.encode(value, forKey: .value)
		try container.encode(coinId, forKey: .coinId)
	}

	public func encode() -> Data? {
		let dataArray = Array<UInt8>(hex: self.to.lowercased().stripMinterHexPrefix())
		guard let toData = Data(dataArray).setLengthLeft(20) else {
			return Data()
		}

		let fields = [coinId, toData, value] as [Any]
		return RLP.encode(fields)
	}
}
