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
	let wallet = AccountManager.default
	let coinManager = CoinManager.default
	let statusManager = StatusManager.default
	let candidateManager = CandidateManager.default
	let validatorManager = ValidatorManager.default
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		wallet.balance(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (resp, error) in
			print("Resp: \(String(describing: resp))")
			print("Error: \(String(describing: error))")
		}

		coinManager.info(symbol: "SHSCOIN") { (coin, error) in
			print("Coin: \(String(describing: coin))")
			print("Error: \(String(describing: error))")
		}

		transactionManager.estimateCoinBuy(from: "MNT", to: "BELTCOIN", amount: Decimal(string: "10000000000000")!) { (value, commission, error) in
			print("Value: \(String(describing: value))")
			print("Commission: \(String(describing: commission))")
			print("Error: \(String(describing: error))")
		}
		
		transactionManager.estimateCoinSell(from: "MNT", to: "BELTCOIN", amount: Decimal(string: "10000000000000")!) { (value, commission, error) in
			print("Value: \(String(describing: value))")
			print("Commission: \(String(describing: commission))")
			print("Error: \(String(describing: error))")
		}
		
		transactionManager.transaction(hash: "Mt6e59d0ad0286c1ec3539de71eb686cad42e7c741") { (transaction, error) in
			print("Transaction: \(transaction)")
		}
		
		/// Making send transaction
		let sendData = SendCoinRawTransactionData(to: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d", value: BigUInt(decimal: 1 * TransactionCoinFactorDecimal)!, coin: "MNT").encode()
		
		let rawTransaction = SendCoinRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", data: sendData!)
		
		/// Signing raw transaction
		let signedTx = RawTransactionSigner.sign(rawTx: rawTransaction, privateKey: "8da1c947b489399a5b07b6bd3d9bb41f7647bb01a28303431b6993a8092f0bed")!
		
		
		/// Sending raw transaction
		transactionManager.send(tx: signedTx) { (txHash, resultText, error) in
			print(txHash)
			print(resultText)
			print(error)
		}
		
		// MARK: -
		
		transactionManager.transactionCount(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (count, error) in
			print("Count: \(String(describing: count))")
			print("Error: \(String(describing: error))")
		}
		
		statusManager.status { (statusDict, error) in
			print(statusDict)
			print(error)
		}
		
		statusManager.baseCoinVolume(height: 2) { (volume, error) in
			print(volume)
			print(error)
		}
		
		candidateManager.candidate(publicKey: "Mp740b1b0f0f4b29cb2fc73e53c8e4b34966a89a97d4e1b86903db6ca2cc1c1596") { (candidate, error) in
			print(candidate)
			print(error)
		}
		
		validatorManager.validators { (validators, error) in
			print(validators)
			print(error)			
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
