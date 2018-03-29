//
//  ViewController.swift
//  MinterCore
//
//  Created by sidorov.panda on 02/19/2018.
//  Copyright (c) 2018 sidorov.panda. All rights reserved.
//

import UIKit
import MinterCore
import CryptoSwift
import secp256k1
import BigInt


class ViewController: UIViewController {
	
	let transactionManager = TransactionManager.default
	let wallet = AccountManager.`default`

	override func viewDidLoad() {
		super.viewDidLoad()
		
		wallet.balance(address: "0xa0ee9e29801935baa8a58686309aafb6a8106edd") { (resp, err)  in
			print(resp)
		}
		
		let coinManager = CoinManager.default
		coinManager.info(symbol: "MNT") { (coin, err) in
			print(coin)
		}
		
		coinManager.estimateExchangeReturn(from: "MNT", to: "MNT", amount: 2.0) { (resp, err) in
			print(resp)
		}
		
		transactionManager.transactions(address: "0xa0ee9e29801935baa8a58686309aafb6a8106edd") { (transactions, error) in
			print(transactions)
		}
		
		transactionManager.transaction(hash: "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331") { (transaction, error) in
			print(transaction)
		}
		
		func calculateRSV(signiture: Data) -> (r: Data, s: Data, v: Data) {
			return (
				r: signiture[..<32],
				s: signiture[32..<64],
				v: Data([signiture[64] + UInt8(27)])
			)
		}
		
		let myAddress = "Mxc07ec7cdcae90dea3999558f022aeb25dabbeea2"
		let privateKey = "c0ed1a463f5d40a0b582c7344a8f25ae3e6132f3f73cc97c1c3f1923e1433a96".data(using: .utf8)
	
		let minterData = MinterTransactionData(to: "Mx32143b4d9674b13b0868da425d049fd66910ebae", value: BigUInt(1), coin: "MINT")
		let encodedData = minterData.encode()
		
		var txx = MinterTransaction(nonce: BigUInt(1), gasPrice: BigUInt(1), type: BigUInt(1), data: encodedData!, v: BigUInt(1), r: BigUInt(0), s: BigUInt(0))
		
		let data = txx.encode(forSignature: true)
		print(data?.toHexString())
		
		let sha3 = SHA3(variant: .keccak256)
		let hash = Data(bytes: sha3.calculate(for: encodedData!.bytes))
		let signature = ViewController.sign(hash, privateKey: privateKey!)
		
		let (r, s, v) = calculateRSV(signiture: signature!)
		
		txx.s = BigUInt(s)
		txx.r = BigUInt(r)
		txx.v = BigUInt(v)
		
		let encoded = txx.encode(forSignature: false)
		print(encoded?.toHexString())
		
		print(RLP.encode([BigUInt(1), BigUInt(1), BigUInt(1), encodedData, v, r, s])?.toHexString())
		
		transactionManager.transaction(hash: encoded!.toHexString().addHexPrefix()) { (tx, err) in
			
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func JSONRPCString(id: String, method: String, params: [String : Any]) -> String? {

		var jsonData: Data

		let raw: [String : Any] = ["jsonrpc":"2.0", "id": id, "method": method, "params": params]
		do {
			jsonData = try JSONSerialization.data(withJSONObject: raw, options: JSONSerialization.WritingOptions.prettyPrinted)
		} catch {
			return nil
		}

		return String(data: jsonData, encoding: .utf8)
	}
	
	
	public static func sign(_ data: Data, privateKey: Data) -> Data? {
		let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
		defer { secp256k1_context_destroy(context) }
		
		var signature = secp256k1_ecdsa_recoverable_signature()
		let status = privateKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
			data.withUnsafeBytes { secp256k1_ecdsa_sign_recoverable(context, &signature, $0, key, nil, nil) }
		}
		
		guard status == 1 else { return nil }
		
		var output = Data(count: 65)
		var recid = 0 as Int32
		_ = output.withUnsafeMutableBytes { (output: UnsafeMutablePointer<UInt8>) in
			secp256k1_ecdsa_recoverable_signature_serialize_compact(context, output, &recid, &signature)
		}
		
		output[64] = UInt8(recid)
		return output
	}
	
	public func verify(privateKey: Data) -> Bool {
		var secret = privateKey.bytes
		let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
		defer { secp256k1_context_destroy(context) }
		
		guard secp256k1_ec_seckey_verify(context, &secret) == 1 else {
			return false
		}
		return true
	}
}
