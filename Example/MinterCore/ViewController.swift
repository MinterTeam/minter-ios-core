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
		
		let accountManager = AccountManager.default
		accountManager.balance(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (resp, error) in
			print("Resp: \(String(describing: resp))")
			print("Error: \(String(describing: error))")
		}

		let coinManager = CoinManager.default
		coinManager.info(symbol: "SHSCOIN") { (coin, error) in
			print("Coin: \(coin)")
			print("Error: \(error)")
		}

		let transactionManager = TransactionManager.default
		transactionManager.estimateCoinBuy(from: "MNT", to: "BELTCOIN", amount: Decimal(string: "10000000000000")!) { (value, commission, error) in
			print("Value: \(value)")
			print("Commission: \(commission)")
			print("Error: \(error)")
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
		let sendData = SendCoinRawTransactionData(to: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d", value:
		BigUInt(decimal: 1 * TransactionCoinFactorDecimal)!, coin: "MNT").encode()
		
		let rawTransaction1 = SendCoinRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", data: sendData!)
		
		let rawTransaction = CreateCoinRawTransaction(nonce: BigUInt(4), gasCoin: "MNT", name: "BELT COIN3", symbol: "BELTCOIN3", initialAmount: BigUInt(decimal: 1000 * TransactionCoinFactorDecimal)!, initialReserve: BigUInt(decimal: 100 * TransactionCoinFactorDecimal)!, reserveRatio: BigUInt(10))
		
		let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"
		
		let seed = String.seedString(mnemonic)!
		let pk = PrivateKey(seed: Data(hex: seed))
		
		let key = pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0)
		
		let publicKey = RawTransactionSigner.publicKey(privateKey: key.raw, compressed: false)!.dropFirst()
		let address = RawTransactionSigner.address(publicKey: publicKey)
		
		/// Signing raw transaction
		let signedTx = RawTransactionSigner.sign(rawTx: rawTransaction, privateKey: key.raw.toHexString())!
		
		/// Sending raw transaction
		transactionManager.send(tx: signedTx) { (txHash, resultText, error) in
			print(txHash)
			print(resultText)
			print(error)
		}
		
		// MARK: -
		transactionManager.transactionCount(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (nonce, error) in
			print("Count: \(nonce)")
			print("Error: \(error)")
		}
		
		let statusManager = StatusManager.default
		
		statusManager.status { (status, error) in
			print(status)
			print(error)
		}
		
		statusManager.baseCoinVolume(height: 2) { (volume, error) in
			print(volume)
			print(error)
		}
		
		let candidateManager = CandidateManager.default
		candidateManager.candidate(publicKey: "Mp740b1b0f0f4b29cb2fc73e53c8e4b34966a89a97d4e1b86903db6ca2cc1c1596") { (candidate, error) in
			print(candidate)
			print(error)
		}

		
		let validatorManager = ValidatorManager.default
		validatorManager.validators { (validators, error) in
			print(validators)
			print(error)
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
}
