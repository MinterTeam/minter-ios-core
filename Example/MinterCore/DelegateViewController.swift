//
//  DelegateViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 23/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import SVProgressHUD
import BigInt


class DelegateViewController: UIViewController {

	//MARK: -
	
	@IBOutlet weak var publicKeyTextField: UITextField!
	
	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBAction func didTapDelegateButton(_ sender: Any) {
		
		let amount = (Decimal(string: amountTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
		
		let tx = DelegateRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", publicKey: publicKeyTextField.text ?? "", coin: coinTextField.text ?? "MNT", value: BigUInt(decimal: amount)!)
		
		let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey.raw.toHexString())
		
		TransactionManager.default.send(tx: signed!) { (res, res1, err) in
			DispatchQueue.main.async {
				
				if nil == err {
					SVProgressHUD.showSuccess(withStatus: res ?? "Done")
				}
				else {
					SVProgressHUD.showError(withStatus: (err as? APIClient.APIClientResponseError)?.userData?.description)
				}
			}
		}
		
	}
	
	//MARK: -
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

}
