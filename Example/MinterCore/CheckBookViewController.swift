//
//  CheckBookViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 18/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import BigInt
import SVProgressHUD


class CheckBookViewController: BaseViewController {
	
	//MARK: - IBOutlet

	@IBOutlet weak var nonceTextField: UITextField!
	
	@IBOutlet weak var dueBlockTextField: UITextField!
	
	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBOutlet weak var passPhraseTextField: UITextField!
	
	@IBOutlet weak var checkTextField: UITextField!
	
	@IBOutlet weak var redeemPassphraseTextField: UITextField!
	
	
	@IBAction func issueButtonDidTap(_ sender: Any) {
		
		let dueBlock = dueBlockTextField.text ?? "999999"
		let amount = amountTextField.text ?? "0"
		let coin = coinTextField.text ?? "MNT"
		let passPhrase = passPhraseTextField.text ?? "pass"
		
		getNonce { (nonce) in
			
			guard let nonce = nonce else {
				SVProgressHUD.showError(withStatus: "Can't get nonce")
				return
			}
			
			let check = self.makeIssueTransaction(nonce: nonce, dueBlock: dueBlock, amount: amount, coin: coin, passPhrase: passPhrase)
			DispatchQueue.main.async {
				if let check = check {
					self.checkTextField.text = check
					SVProgressHUD.showSuccess(withStatus: check)
				}
				else {
					SVProgressHUD.showError(withStatus: "Can't create check")
				}
			}
		}
	}
	
	@IBAction func redeemButtonDidTap(_ sender: Any) {
		
		let pk = Session.shared.privateKey.raw.toHexString()
		
		let rawCheck = Data(hex: checkTextField.text?.stripMinterCheckHexPrefix() ?? "")
		
		let pubKey = RawTransactionSigner.publicKey(privateKey: Data(hex: pk), compressed: false)!.dropFirst()
		
		let address = RawTransactionSigner.address(privateKey: pk)!
		
		let proof = RawTransactionSigner.proof(address: address, passphrase: redeemPassphraseTextField.text ?? "")
		
		let data = RedeemCheckRawTransactionData(rawCheck: rawCheck, proof: proof!)
		
		let gasCoin = "MNT"
		
		getNonce { (nonce) in
			
			guard let nonce = nonce else {
				SVProgressHUD.showError(withStatus: "Can't get nonce")
				return
			}
		
			let tx = RedeemCheckRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, rawCheck: rawCheck, proof: proof!)!
			tx.data = data.encode()!
			
			let result = RawTransactionSigner.sign(rawTx: tx, privateKey: pk)
			
			TransactionManager.default.send(tx: "Mt" + result!) { (res, ress, err) in
				
				guard nil == err else {
					SVProgressHUD.showError(withStatus: err.debugDescription ?? "")
					return
				}
				
				SVProgressHUD.showError(withStatus: "Check has been redeemed")
				
			}
		}
		
	}
	
	//MARK: - View Controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	//MARK: -
	
	func makeIssueTransaction(nonce: BigUInt, dueBlock: String = "999999", amount: String, coin: String, passPhrase: String) -> String? {
		
		let due = BigUInt(dueBlock) ?? BigUInt(0)
		let val = BigUInt(amount) ?? BigUInt(0)
		
		var tx = IssueCheckRawTransaction(nonce: nonce, dueBlock: due, coin: coin, value: val, passPhrase: passPhrase)
		let check = tx.serialize(privateKey: Session.shared.privateKey.raw.toHexString(), passphrase: passPhrase)
		return check
	}

}
