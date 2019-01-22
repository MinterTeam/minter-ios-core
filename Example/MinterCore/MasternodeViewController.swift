//
//  MasternodeViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 19/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import BigInt
import SVProgressHUD


class MasternodeViewController: UIViewController {
	
	//MARK: -
	
	@IBOutlet weak var publicKeyTextField: UITextField!
	
	@IBOutlet weak var stakeTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBOutlet weak var commissionTextField: UITextField!
	
	@IBAction func didTapDeclareCandidacyButton(_ sender: Any) {
		
		SVProgressHUD.showProgress(0.5)
		
		DispatchQueue.global().async {
			let publicKey = self.publicKeyTextField.text ?? ""
			let commission = Decimal(string: self.commissionTextField.text ?? "0") ?? 0
			let coin = self.coinTextField.text ?? "MNT"
			let stake = (Decimal(string: self.stakeTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
			
			let tx = DeclareCandidacyRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", address: Session.shared.address, publicKey: publicKey, commission: BigUInt(decimal: commission)!, coin: coin, stake: BigUInt(decimal: stake)!)
			
			let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey.raw.toHexString())
			
			TransactionManager.default.send(tx: signed!) { (res, res1, error) in
				
				DispatchQueue.main.async {
					
					if nil == error {
						SVProgressHUD.showSuccess(withStatus: res ?? "Done")
					}
					else {
						SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
					}
				}
			}
		}
	}
	
	@IBAction func didTapTurnOnButton(_ sender: Any) {
		
		SVProgressHUD.showProgress(0.5)
		
		DispatchQueue.global().async {
			let tx = SetCandidateOnlineRawTransaction(nonce: BigUInt(2), gasCoin: "MNT", publicKey: self.publicKeyTextField.text ?? "")
			let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey.raw.toHexString())
			
			TransactionManager.default.send(tx: signed!) { res, res1, error in
				DispatchQueue.main.async {
					
					if nil == error {
						SVProgressHUD.showSuccess(withStatus: res ?? "Done")
					}
					else {
						SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
					}
				}
			}
		}
	}
	
	@IBAction func didTapTurnOff(_ sender: Any) {
		
		SVProgressHUD.showProgress(0.5)
		DispatchQueue.global().async {
			let tx = SetCandidateOfflineRawTransaction(nonce: BigUInt(3), gasCoin: "MNT", publicKey: self.publicKeyTextField.text ?? "")
			let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey.raw.toHexString())
			
			TransactionManager.default.send(tx: signed!) { res, res1, error in
				DispatchQueue.main.async {
					
					if nil == error {
						SVProgressHUD.showSuccess(withStatus: res ?? "Done")
					}
					else {
						SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
					}
				}
			}
		}
		
	}
	
	
	
	
	//MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	//MARK: -

}
