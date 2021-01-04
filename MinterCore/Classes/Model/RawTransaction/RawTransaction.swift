//
//  RawTransaction
//  MinterCore
//
//  Created by Alexey Sidorov on 30/03/2018.
//

import Foundation
import Alamofire
import BigInt

public protocol RLPEncodable: Encodable {
	func encode() -> Data?
}

public protocol SignatureRLPEncodable: RLPEncodable {
	func encode(forSignature: Bool) -> Data?
}

public let RawTransactionDefaultTransactionCoin = Coin.baseCoin().symbol ?? "MNT"
public let RawTransactionDefaultGasPrice = 1

public enum RawTransactionTypeCommissionOption: String {
	case multisendCount
	case coinSymbolLettersCount
}

public enum RawTransactionError: Error {
  case invalidTransactionData
}

/// Transaction type
/// - SeeAlso: https://minter-go-node.readthedocs.io/en/docs/transactions.html#types
public enum RawTransactionType: Int {
	case sendCoin = 0x01
	case sellCoin = 0x02
	case sellAllCoins = 0x03
	case buyCoin = 0x04
	case createCoin = 0x05
	case declareCandidacy = 0x06
	case delegate = 0x07
	case unbond = 0x08
	case redeemCheck = 0x09
	case setCandidateOnline = 0x0A
	case setCandidateOffline = 0x0B
	case createMultisigAddress = 0x0C
	case multisend = 0x0D
	case editCandidate = 0x0E
  case setHaltBlock = 0x0F
  case recreateCoin = 0x10
  case changeCoinOwner = 0x11
  case editMultisigOwner = 0x12
  case priceVote = 0x13
  case editCandidatePublicKey = 0x14

	public func BigUIntValue() -> BigUInt {
		return BigUInt(self.rawValue)
	}

  static let commissionUnit = pow(10, 15)

	/// Comission for a transaction in pips
	/// - SeeAlso: https://www.minter.network/docs#commissions
	public func commission(options: [RawTransactionTypeCommissionOption: Any] = [:]) -> Decimal {
		switch self {
    case .sendCoin: return 10 * RawTransactionType.commissionUnit
		case .sellCoin, .buyCoin, .sellAllCoins: return 100 * RawTransactionType.commissionUnit
		case .createCoin:
			var coinSymbolLettersCount = 0
			if let coinLength = options[.coinSymbolLettersCount] as? Int {
				coinSymbolLettersCount = coinLength
			}
			if coinSymbolLettersCount <= 3 {
				return 10_000_000_000 * TransactionCoinFactorDecimal
			} else if coinSymbolLettersCount == 4 {
				return 1_000_000_000 * TransactionCoinFactorDecimal
			} else if coinSymbolLettersCount == 5 {
				return 100_000_000 * TransactionCoinFactorDecimal
			} else if coinSymbolLettersCount == 6 {
				return 10_000_000 * TransactionCoinFactorDecimal
			}
			return 1_000_000 * TransactionCoinFactorDecimal
		case .declareCandidacy: return 10_000 * RawTransactionType.commissionUnit
		case .delegate: return 200 * RawTransactionType.commissionUnit
		case .unbond: return 200 * RawTransactionType.commissionUnit
		case .redeemCheck: return 30 * RawTransactionType.commissionUnit
		case .setCandidateOnline: return 100 * RawTransactionType.commissionUnit
		case .setCandidateOffline: return 100 * RawTransactionType.commissionUnit
		case .createMultisigAddress: return 100 * RawTransactionType.commissionUnit
		case .multisend:
			var multisendCount: Int = 0
			if let count = options[.multisendCount] as? Int {
				multisendCount = count
			}
			return (10 + Decimal(max(0, multisendCount - 1)) * 5) * RawTransactionType.commissionUnit
		case .editCandidate: return 10_000 * RawTransactionType.commissionUnit
    case .setHaltBlock: return 1_000 * RawTransactionType.commissionUnit
    case .recreateCoin: return 10_000_000 * RawTransactionType.commissionUnit
    case .changeCoinOwner: return 10_000_000 * RawTransactionType.commissionUnit
    case .editMultisigOwner: return 1_000 * RawTransactionType.commissionUnit
    case .priceVote: return 10 * RawTransactionType.commissionUnit
    case .editCandidatePublicKey: return 10_000_000 * RawTransactionType.commissionUnit
    }
	}
}

/// A base class for all RawTransactions
open class RawTransaction: Encodable, Decodable, SignatureRLPEncodable {

	public struct SignatureData: Encodable, Decodable, RLPEncodable {
		public var v: BigUInt?
		public var s: BigUInt?
		public var r: BigUInt?

    public var multisigAddress: String?
    public var signatures = [(v: Data, r: Data, s: Data)]()

		public init(v: BigUInt = BigUInt(1),
								r: BigUInt = BigUInt(0),
								s: BigUInt = BigUInt(0)) {
			self.v = v
			self.r = r
			self.s = s
		}

    public init(multisigAddress: String, signatures: [(v: Data, r: Data, s: Data)]) {
      self.multisigAddress = multisigAddress
      self.signatures = signatures
    }

		public init(from decoder: Decoder) throws {
			let values = try decoder.container(keyedBy: CodingKeys.self)
			self.v = try values.decode(BigUInt.self, forKey: .v)
			self.s = try values.decode(BigUInt.self, forKey: .s)
			self.r = try values.decode(BigUInt.self, forKey: .r)
		}

		// MARK: - RLPEncodable

		public func encode() -> Data? {
      if !signatures.isEmpty {
        guard
          let multisigAddress = multisigAddress,
          let address = Data(hexString: multisigAddress.stripMinterHexPrefix()) else {
            return nil
        }
        return RLP.encode([address, signatures.map { (data) -> [Data] in
          return [data.v, data.r, data.s]
        }])
      }

      guard let v = self.v, let r = self.r, let s = self.s else {
        return nil
      }

			let fields = [self.v, self.r, self.s] as [Any]
			return RLP.encode(fields)
		}

		// MARK: - Encodable

		enum CodingKeys: String, CodingKey {
			case v
			case r
			case s
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.container(keyedBy: CodingKeys.self)
			try container.encode(v, forKey: .v)
			try container.encode(r, forKey: .r)
			try container.encode(s, forKey: .s)
		}
	}

	public static let maxPayloadSize = 1024
	public static let payloadByteComissionPrice = Decimal(0.002)

	/// Used for prevent transaction reply
	public var nonce: BigUInt
	/// Chain Id, 1 - mainnet, 2 - testnet
	public var chainId: Int = MinterCoreSDK.shared.network.rawValue
	/// Used for managing transaction fees
	public var gasPrice: BigUInt = BigUInt(RawTransactionDefaultGasPrice)
	/// Coin which will be used to get commission from
	public var gasCoinId: Int = Coin.baseCoin().id!
	/// Transaction type
	/// - SeeAlso: https://minter-go-node.readthedocs.io/en/docs/transactions.html#types
	public var type: BigUInt = BigUInt(1)
	/// Data encoded with RLP, the contents of its depend on the Tx type
	public var data: Data
	/// Arbitrary user-defined bytes
	/// Using this field requires an extra commission (about 1 pip per byte)
	public var payload: Data
	/// Reserved field
	/// Using this field requires an extra commission (about 1 pip per byte)
	public var serviceData: Data
  /// signatureType:  1 - simple, 2 - multisignature
	public var signatureType: BigUInt
	/// SignatureData
	public var signatureData: SignatureData

	// MARK: -

	/**
	RawTransaction initializer
	- Parameters:
	- nonce: BigUInt value of nonce
	- chainId: 1 - mainnet, 2 - testnet
	- gasPrice: BigUInt value of price
	- gasCoin: Data
	- type: BigUInt value of transaction type
	- data: Transaction Data object
	- payload: Payload Data object
	- serviceData: ServiceData Data object
  - signatureType: Signature type, 1 - simple, 2 - multisignature
	- Precondition:
	- nonce value can be retreived from the Minter Network, for exmple by calling this method https://minter-go-node.readthedocs.io/en/docs/api.html#transaction-count
	- gasCoin: 10 bytes of coin symbol, if the byte count less than 10 add 0 bytes from the right (e.g. UInt8([77, 78, 84, 0, 0, 0, 0, 0, 0, 0])
	- data: RLP-encoded data
	- Returns: Signed RawTx hex string, which can be send to Minter Node
	*/
	public init(nonce: BigUInt,
							chainId: Int = MinterCoreSDK.shared.network.rawValue,
							gasPrice: BigUInt = BigUInt(RawTransactionDefaultGasPrice),
							gasCoinId: Int,
							type: BigUInt,
							data: Data = Data(),
							payload: Data,
							serviceData: Data,
							signatureType: BigUInt = BigUInt(1),
							signatureData: SignatureData = SignatureData()) {
		self.nonce = nonce
		self.chainId = chainId
		self.gasPrice = gasPrice
		self.gasCoinId = gasCoinId
		self.type = type
		self.data = data
		self.payload = payload
		self.serviceData = serviceData
		self.signatureType = signatureType
		self.signatureData = signatureData
	}

	/// Convenience initializer
	///
	/// - Parameters:
	///   - nonce: Nonce
	///   - chainId, 1 - mainnet, 2 - testnet
	///   - gasCoin: Coin to spend fee from
	///   - data: Encoded data
	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasPrice: BigUInt = BigUInt(RawTransactionDefaultGasPrice),
													gasCoinId: Int,
													type: BigUInt,
													data: Data,
													payload: Data = Data(),
													serviceData: Data = Data()) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: gasPrice,
							gasCoinId: gasCoinId,
							type: type,
							payload: payload,
							serviceData: serviceData)
		self.data = data
	}

	required public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		self.nonce = try values.decode(BigUInt.self, forKey: .nonce)
		self.chainId = try values.decode(Int.self, forKey: .chainId)
		self.gasPrice = try values.decode(BigUInt.self, forKey: .gasPrice)
		self.gasCoinId = try values.decode(Int.self, forKey: .gasCoinId)
		self.type = try values.decode(BigUInt.self, forKey: .type)
		self.data = try values.decode(Data.self, forKey: .data)
		self.payload = try values.decode(Data.self, forKey: .payload)
		self.serviceData = try values.decode(Data.self, forKey: .serviceData)
		self.signatureType = try values.decode(BigUInt.self, forKey: .signatureType)
		self.signatureData = try values.decode(SignatureData.self, forKey: .signatureData)
	}

	// MARK: - Encodable

	enum CodingKeys: String, CodingKey {
		case nonce
		case chainId
		case gasPrice
		case gasCoinId
		case type
		case data
		case payload
		case serviceData
		case signatureType
		case signatureData
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(nonce, forKey: .nonce)
		try container.encode(chainId, forKey: .chainId)
		try container.encode(gasPrice, forKey: .gasPrice)
		try container.encode(gasCoinId, forKey: .gasCoinId)
		try container.encode(type, forKey: .type)
		try container.encode(data, forKey: .data)
		try container.encode(payload, forKey: .payload)
		try container.encode(serviceData, forKey: .serviceData)
		try container.encode(signatureType, forKey: .signatureType)
		try container.encode(signatureData, forKey: .signatureData)
	}

	// MARK: - SignatureRLPEncodable

	public func encode(forSignature: Bool = false) -> Data? {

		if forSignature {
			let fields = [self.nonce,
										self.chainId,
										self.gasPrice,
										self.gasCoinId,
										self.type,
										self.data,
										self.payload,
										self.serviceData,
										self.signatureType] as [Any]
			return RLP.encode(fields)
		} else {
			let fields = [self.nonce,
										self.chainId,
										self.gasPrice,
										self.gasCoinId,
										self.type,
										self.data,
										self.payload,
										self.serviceData,
										self.signatureType,
										self.signatureData.encode() ?? Data()] as [Any]
			return RLP.encode(fields)
		}
	}

	// MARK: - RLPEncodable

	public func encode() -> Data? {
		return self.encode(forSignature: false)
	}
}
