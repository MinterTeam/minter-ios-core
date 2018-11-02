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


class CheckBookViewController: UIViewController {
	
	//MARK: - IBOutlet

	@IBOutlet weak var nonceTextField: UITextField!
	
	@IBOutlet weak var dueBlockTextField: UITextField!
	
	@IBOutlet weak var amountTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBOutlet weak var passPhraseTextField: UITextField!
	
	@IBOutlet weak var checkTextField: UITextField!
	
	@IBOutlet weak var redeemPassphraseTextField: UITextField!
	
	
	@IBAction func issueButtonDidTap(_ sender: Any) {
		let check = makeIssueTransaction(nonce: nonceTextField.text ?? "1", dueBlock: dueBlockTextField.text ?? "999999", amount: amountTextField.text ?? "0", coin: coinTextField.text ?? "MNT", passPhrase: passPhraseTextField.text ?? "pass")
		if let check = check {
			checkTextField.text = check
			
			SVProgressHUD.showSuccess(withStatus: check)
		}
		else {
			SVProgressHUD.showError(withStatus: "Can't create check")
		}
	}
	
	@IBAction func redeemButtonDidTap(_ sender: Any) {
		
		let pk = Session.shared.privateKey.raw.toHexString()
		
		let rawCheck = Data(hex: checkTextField.text?.stripMinterCheckHexPrefix() ?? "")
		
		let pubKey = RawTransactionSigner.publicKey(privateKey: Data(hex: pk), compressed: false)!.dropFirst()
		
		let address = RawTransactionSigner.address(privateKey: pk)!
		
		let proof = RawTransactionSigner.proof(address: address, passphrase: redeemPassphraseTextField.text ?? "")
		
		let data = RedeemCheckRawTransactionData(rawCheck: rawCheck, proof: proof!)
		
		let gasCoin = "MNT".data(using: .utf8)!.setLengthRight(10)
		let tx = RedeemCheckRawTransaction(nonce: BigUInt(1), gasPrice: BigUInt(1), gasCoin: gasCoin!, type: BigUInt(9), payload: Data(), serviceData: Data())
		tx.data = data.encode()!
		
		let result = RawTransactionSigner.sign(rawTx: tx, privateKey: pk)
		
		TransactionManager.default.send(tx: result!) { (res, ress, err) in
			
			guard nil == err else {
				SVProgressHUD.showError(withStatus: err.debugDescription ?? "")
				return
			}
			
			SVProgressHUD.showError(withStatus: "Check has been redeemed")
			
		}
		
	}
	
	//MARK: - View Controller
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	//MARK: -
	
	func makeIssueTransaction(nonce: String = "0", dueBlock: String = "999999", amount: String, coin: String, passPhrase: String) -> String? {
		
		let nonce = BigUInt(nonce) ?? BigUInt(0)
		let due = BigUInt(dueBlock) ?? BigUInt(0)
		let val = BigUInt(amount) ?? BigUInt(0)
		
		var tx = IssueCheckRawTransaction(nonce: nonce, dueBlock: due, coin: coin, value: val, passPhrase: passPhrase)
		let check = tx.serialize(privateKey: Session.shared.privateKey.raw.toHexString(), passphrase: passPhrase)
		return check
	}

}
