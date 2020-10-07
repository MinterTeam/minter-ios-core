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
													gasCoinId: Int,
													data: Data) {

		self.init(nonce: nonce,
							chainId: chainId,
							gasPrice: BigUInt(RawTransactionDefaultGasPrice),
							gasCoinId: gasCoinId,
							type: RawTransactionType.createMultisigAddress.BigUIntValue(),
							payload: Data(),
							serviceData: Data())
		self.data = data
	}

  public convenience init(nonce: BigUInt,
                          chainId: Int = MinterCoreSDK.shared.network.rawValue,
                          gasCoinId: Int,
                          threshold: BigUInt,
                          weights: [BigUInt],
                          addresses: [String]) {

    self.init(nonce: nonce,
              chainId: chainId,
              gasPrice: BigUInt(RawTransactionDefaultGasPrice),
              gasCoinId: gasCoinId,
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
