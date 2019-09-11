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


class DelegateViewController: BaseViewController {

	//MARK: -
	
	@IBOutlet weak var publicKeyTextField: UITextField!
	
	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBAction func didTapDelegateButton(_ sender: Any) {
		
		let amount = (Decimal(string: amountTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
		let coin = coinTextField.text ?? "MNT"
		let publicKey = publicKeyTextField.text ?? ""
		
		getNonce { (nonce) in
			
			guard let nonce = nonce else {
				return
			}
			
			let tx = DelegateRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", publicKey: publicKey, coin: coin, value: BigUInt(decimal: amount)!)
			
			let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())
			
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
	
	//MARK: -
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

}
