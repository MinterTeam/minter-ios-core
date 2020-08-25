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


class MasternodeViewController: BaseViewController {
	
	//MARK: -
	
	@IBOutlet weak var publicKeyTextField: UITextField!
	
	@IBOutlet weak var stakeTextField: UITextField!
	
	@IBOutlet weak var coinTextField: UITextField!
	
	@IBOutlet weak var commissionTextField: UITextField!
	
	@IBAction func didTapDeclareCandidacyButton(_ sender: Any) {
		
		let publicKey = self.publicKeyTextField.text ?? ""
		let commission = Decimal(string: self.commissionTextField.text ?? "0") ?? 0
    let coinId = Coin.baseCoin().id!
		let stake = (Decimal(string: self.stakeTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal
		
		SVProgressHUD.showProgress(0.5)
		DispatchQueue.global().async {
			self.getNonce(completion: { (nonce) in
				
				guard let nonce = nonce else {
					SVProgressHUD.showError(withStatus: "Can't get nonce")
					return
				}

				
				let tx = DeclareCandidacyRawTransaction(nonce: nonce, chainId: 2, gasCoinId: 0, address: Session.shared.address, publicKey: publicKey, commission: BigUInt(decimal: commission)!, coinId: coinId, stake: BigUInt(decimal: stake)!)
				
				let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())
				
				TransactionManager.default.send(tx: "Mt" + signed!) { (res, res1, error) in
					
					DispatchQueue.main.async {
						
						if nil == error {
							SVProgressHUD.showSuccess(withStatus: res ?? "Done")
						}
						else {
							SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
						}
					}
				}
			})
		}
	}
	
	@IBAction func didTapTurnOnButton(_ sender: Any) {
		
		SVProgressHUD.showProgress(0.5)
		
		DispatchQueue.global().async {
			self.getNonce(completion: { (nonce) in
				
				guard let nonce = nonce else {
					SVProgressHUD.showError(withStatus: "Can't get nonce")
					return
				}
				let tx = SetCandidateOnlineRawTransaction(nonce: nonce, chainId: 2, gasCoinId: 0, publicKey: self.publicKeyTextField.text ?? "")
				let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())
				
				TransactionManager.default.send(tx: "Mt" + signed!) { res, res1, error in
					DispatchQueue.main.async {
						
						if nil == error {
							SVProgressHUD.showSuccess(withStatus: res ?? "Done")
						}
						else {
							SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
						}
					}
				}
			})
		}
	}
	
	@IBAction func didTapTurnOff(_ sender: Any) {
		
		let publicKey = self.publicKeyTextField.text ?? ""
		
		SVProgressHUD.showProgress(0.5)
		DispatchQueue.global().async {

			self.getNonce(completion: { (nonce) in
				
				guard let nonce = nonce else {
					SVProgressHUD.showError(withStatus: "Can't get nonce")
					return
				}
				
				let tx = SetCandidateOfflineRawTransaction(nonce: nonce, chainId: 2, gasCoinId: 0, publicKey: publicKey)
				let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())
				
				TransactionManager.default.send(tx: "Mt" + signed!) { res, res1, error in
					DispatchQueue.main.async {
						
						if nil == error {
							SVProgressHUD.showSuccess(withStatus: res ?? "Done")
						}
						else {
							SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
						}
					}
				}
			})
		}
	}
	
	//MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	//MARK: -

}
