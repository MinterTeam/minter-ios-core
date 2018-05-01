//
//  ViewController.swift
//  MinterCore
//
//  Created by sidorov.panda on 02/19/2018.
//  Copyright (c) 2018 sidorov.panda. All rights reserved.
//

import UIKit
import MinterCore
import BigInt


class ViewController: UIViewController {
	
	let transactionManager = TransactionManager.default
	let wallet = AccountManager.`default`

	override func viewDidLoad() {
		super.viewDidLoad()
		
//		wallet.balance(address: "Mxa93163fdf10724dc4785ff5cbfb9ac0b5949409f") { (resp, err)  in
//			print(resp)
//		}
//
//		let coinManager = CoinManager.default
//		coinManager.info(symbol: "MNT") { (coin, err) in
//			print(coin)
//		}
//
//		coinManager.estimateExchangeReturn(from: "MNT", to: "MNT", amount: 2.0) { (resp, err) in
//			print(resp)
//		}
//
//		transactionManager.transactions(address: "Mxa93163fdf10724dc4785ff5cbfb9ac0b5949409f") { (transactions, error) in
//			print(transactions)
//		}
//
//		transactionManager.transaction(hash: "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331") { (transaction, error) in
//			print(transaction)
//		}

		let encodedData = RawTransactionData(to: "Mxc3a55cdb5bcb97fd5657794247de4ed5e4a49f0d", value: BigUInt(1000), coin: "MINT").encode()
		
		let tx = RawTransaction(nonce: BigUInt(7), gasPrice: BigUInt(1), type: BigUInt(1), data: encodedData!, v: BigUInt(1), r: BigUInt(0), s: BigUInt(0))
		
		let signedHex = RawTransactionSigner.sign(rawTx: tx, privateKey: "c0ed1a463f5d40a0b582c7344a8f25ae3e6132f3f73cc97c1c3f1923e1433a96")
		
		transactionManager.send(tx: signedHex!) { (suc, err) in
			
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
