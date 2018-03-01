//
//  ViewController.swift
//  MinterCore
//
//  Created by sidorov.panda on 02/19/2018.
//  Copyright (c) 2018 sidorov.panda. All rights reserved.
//

import UIKit
import MinterCore
import web3swift

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let wallet = AccountManager.`default`
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
		
		let transactionManager = TransactionManager.default
		transactionManager.transactions(address: "0xa0ee9e29801935baa8a58686309aafb6a8106edd") { (transactions, error) in
			print(transactions)
		}
		
		transactionManager.transaction(hash: "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331") { (transaction, error) in
			print(transaction)
		}
		
		
		

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

}

