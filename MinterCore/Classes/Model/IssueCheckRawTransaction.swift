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

	public var nonce: BigUInt
	public var dueBlock: BigUInt = BigUInt(999999)
	public var coin: String
	public var value: BigUInt
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
	///   - passPhrase: Phrase to activate check
	public init(nonce: BigUInt = BigUInt(1),
							dueBlock: BigUInt = BigUInt(999999),
							coin: String = "MNT",
							value: BigUInt,
							passPhrase: String) {
		self.nonce = nonce
		self.dueBlock = dueBlock
		self.coin = coin
		self.value = value
		self.passPhrase = passPhrase
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.nonce = try values.decode(BigUInt.self, forKey: .nonce)
		self.dueBlock = try values.decode(BigUInt.self, forKey: .dueBlock)
		self.coin = try values.decode(String.self, forKey: .coin)
		self.value = try values.decode(BigUInt.self, forKey: .value)
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
		case dueBlock
		case coin
		case value
		case passPhrase
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(nonce, forKey: .nonce)
		try container.encode(dueBlock, forKey: .dueBlock)
		try container.encode(coin, forKey: .coin)
		try container.encode(value, forKey: .value)
		try container.encode(passPhrase, forKey: .passPhrase)
	}

	private func encode(forSigning: Bool) -> Data? {
		let coinData = coin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)

		var fields: [Any]?
		if forSigning {
			fields = [nonce, dueBlock, coinData, value] as [Any]
		} else {
			guard nil != lock else {
				return nil
			}

			if nil != v && nil != r && nil != s {
				fields = [nonce, dueBlock, coinData, value, lock!, v!, r!, s!] as [Any]
			} else {
				fields = [nonce, dueBlock, coinData, value, lock!] as [Any]
			}
		}
		return RLP.encode(fields)
	}
}
