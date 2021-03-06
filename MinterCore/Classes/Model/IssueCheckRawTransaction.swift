//
//  IssueCheckRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 18/10/2018.
//

import Foundation
import BigInt
import CryptoSwift

public struct IssueCheckRawTransaction: Encodable, Decodable {

	public var nonce: String
  public var chainId: Int
	public var dueBlock: BigUInt = BigUInt(999999)
	public var coin: String
	public var value: BigUInt
  public var gasCoin: String
	public var passPhrase: String
	public var lock: Data?
	public var r: BigUInt?
	public var s: BigUInt?
	public var v: BigUInt?

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - dueBlock: Block due which check available
	///   - coin: Check coin
	///   - value: Check value
  ///   - gasCoin: Gas coin to pay commission
	///   - passPhrase: Phrase to activate check
	public init(nonce: String,
              chainId: Int = MinterCoreSDK.shared.network.rawValue,
							dueBlock: BigUInt = BigUInt(9999999),
							coin: String = Coin.baseCoin().symbol!,
							value: BigUInt,
              gasCoin: String = Coin.baseCoin().symbol!,
							passPhrase: String) {
		self.nonce = nonce
    self.chainId = chainId
		self.dueBlock = dueBlock
		self.coin = coin
		self.value = value
    self.gasCoin = gasCoin
		self.passPhrase = passPhrase
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.nonce = try values.decode(String.self, forKey: .nonce)
    self.chainId = try values.decode(Int.self, forKey: .chainId)
		self.dueBlock = try values.decode(BigUInt.self, forKey: .dueBlock)
		self.coin = try values.decode(String.self, forKey: .coin)
		self.value = try values.decode(BigUInt.self, forKey: .value)
    self.gasCoin = try values.decode(String.self, forKey: .gasCoin)
		self.passPhrase = try values.decode(String.self, forKey: .passPhrase)
	}

	// MARK: -

	public mutating func serialize(privateKey: String, passphrase: String) -> String? {
		guard let hashBytes = encode(forSigning: true) else {
			return nil
		}

		let hash = hashBytes.sha3(.keccak256)

		let pk = passphrase.sha256().dataWithHexString()
		let lockSig = RawTransactionSigner.signCheck(hash, privateKey: pk)

		guard nil != lockSig.r && nil != lockSig.s && nil != lockSig.v else {
			return nil
		}

		let locker = Data(lockSig.r! + lockSig.s! + lockSig.v!)
		self.lock = locker
		self.r = nil
		self.s = nil
		self.v = nil

		guard let withLock = encode(forSigning: false)?.sha3(.keccak256) else {
			return nil
		}

		let rsv = RawTransactionSigner.sign(withLock, privateKey: Data(hex: privateKey))

		guard nil != rsv.r && nil != rsv.s && nil != rsv.v else {
			return nil
		}

		self.r = BigUInt(rsv.r!)
		self.s = BigUInt(rsv.s!)
		self.v = BigUInt(rsv.v!)

		guard let signedCheck = self.encode(forSigning: false)?.toHexString() else {
			return nil
		}
		return "Mc" + signedCheck
	}

	// MARK: - Encoding

	enum CodingKeys: String, CodingKey {
		case nonce
    case chainId
		case dueBlock
		case coin
		case value
    case gasCoin
		case passPhrase
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(nonce, forKey: .nonce)
    try container.encode(chainId, forKey: .chainId)
		try container.encode(dueBlock, forKey: .dueBlock)
		try container.encode(coin, forKey: .coin)
		try container.encode(value, forKey: .value)
    try container.encode(gasCoin, forKey: .gasCoin)
		try container.encode(passPhrase, forKey: .passPhrase)
	}

	private func encode(forSigning: Bool) -> Data? {
		let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
    let gasCoinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)

		var fields: [Any]?
		if forSigning {
			fields = [nonce, chainId, dueBlock, coinData, value, gasCoinData] as [Any]
		} else {
			guard nil != lock else {
				return nil
			}

			if nil != v && nil != r && nil != s {
				fields = [nonce, chainId, dueBlock, coinData, value, gasCoinData, lock!, v!, r!, s!] as [Any]
			} else {
				fields = [nonce, chainId, dueBlock, coinData, value, gasCoinData, lock!] as [Any]
			}
		}
		return RLP.encode(fields)
	}
}
