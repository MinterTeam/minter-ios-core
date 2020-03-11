//
//  CreateMultisigAddressRawTransaction.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 11/01/2019.
//

import Foundation
import BigInt

/// CreateMultisigAddressRawTransaction Class
public class CreateMultisigAddressRawTransaction: RawTransaction {

	public convenience init(nonce: BigUInt,
													chainId: Int = MinterCoreSDK.shared.network.rawValue,
													gasCoin: String,
													data: Data) {

		let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(RawTransactionDefaultGasPrice),
							gasCoin: coinData,
							type: RawTransactionType.createMultisigAddress.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasCoin: String,
                          threshold: BigUInt,
                          weights: [BigUInt],
                          addresses: [String]) {

    let coinData = gasCoin.data(using: .utf8)?.setLengthRight(10) ?? Data(repeating: 0, count: 10)
    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(RawTransactionDefaultGasPrice),
              gasCoin: coinData,
              type: RawTransactionType.createMultisigAddress.BigUIntValue(),
              payload: Data(),
              serviceData: Data())
    let data = CreateMultisigAddressRawTransactionData(threshold: threshold, weights: weights, addresses: addresses).encode()
    self.data = data ?? Data()
  }

}

/// CreateMultisigAddressRawTransactionData class
public struct CreateMultisigAddressRawTransactionData {

	public var threshold: BigUInt

	public var weights: [BigUInt]

	public var addresses: [String]

	// MARK: -

	public init(threshold: BigUInt, weights: [BigUInt], addresses: [String]) {
		self.threshold = threshold
		self.weights = weights
		self.addresses = addresses
	}

	// MARK: - RLPEncoding

	public func encode() -> Data? {
		let newAddresses = self.addresses.map { (str) -> Data? in
			return Data(hex: str.stripMinterHexPrefix())
			}.filter { (data) -> Bool in
				return data != nil
		} as! [Data]
		let fields = [self.threshold, self.weights, newAddresses] as [Any]
		return RLP.encode(fields)
	}
}
