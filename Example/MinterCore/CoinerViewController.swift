//
//  CoinerViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 19/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import BigInt
import SVProgressHUD


class CoinerViewController: BaseViewController {
	
	//MARK: -

	@IBOutlet weak var coinNameTextField: UITextField!
	
	@IBOutlet weak var coinSymbolTextField: UITextField!
	
	@IBOutlet weak var initialAmountTextField: UITextField!
	
	@IBOutlet weak var initialReserveTextField: UITextField!
	
	@IBOutlet weak var constantReserveRatioTextField: UITextField!
	
	@IBAction func createButtonDidTap(_ sender: Any) {
		
		let normalizedAmount = (Decimal(string: initialAmountTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
		let normalizedReserve = (Decimal(string: initialReserveTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
		
		let name = coinNameTextField.text ?? ""
		let symbol = coinSymbolTextField.text ?? ""
		
		guard
		let normalizedReserveRatio = Decimal(string: constantReserveRatioTextField.text ?? "0"),
		let initialAmount = BigUInt(decimal: normalizedAmount),
		let initialReserve = BigUInt(decimal: normalizedReserve),
		let reserveRatio = BigUInt(decimal: normalizedReserveRatio) else {
			//Show error
			return
		}
		
		getNonce { (nonce) in
			
			guard let nonce = nonce else {
				SVProgressHUD.showError(withStatus: "Can't get nonce")
				return
			}
			
			let data = CreateCoinRawTransactionData(name: name, symbol: symbol, initialAmount: initialAmount, initialReserve: initialReserve, reserveRatio: reserveRatio)
			
			let tx = CreateCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", data: data.encode()!)
			
			let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey.raw.toHexString())
			
			TransactionManager.default.send(tx: "Mt" + signed!) { (res, res1, err) in
				DispatchQueue.main.async {
					
					if nil == err {
						SVProgressHUD.showSuccess(withStatus: res ?? "Done")
					}
					else {
						SVProgressHUD.showError(withStatus: (err as? HTTPClientError)?.userData?.description)
					}
				}
			}
		}
		
		
	}
	
	//MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	//MARK: -
	
}
