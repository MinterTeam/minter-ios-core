//
//  MasternodeViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 19/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BigInt
import MinterCore
import SVProgressHUD
import UIKit

class MasternodeViewController: BaseViewController {
    // MARK: -

    @IBOutlet var publicKeyTextField: UITextField!

    @IBOutlet var stakeTextField: UITextField!

    @IBOutlet var coinTextField: UITextField!

    @IBOutlet var commissionTextField: UITextField!

    @IBAction func didTapDeclareCandidacyButton(_: Any) {
        let publicKey = publicKeyTextField.text ?? ""
        let commission = Decimal(string: commissionTextField.text ?? "0") ?? 0
        let coin = coinTextField.text ?? "MNT"
        let stake = (Decimal(string: stakeTextField.text ?? "0") ?? 0) * TransactionCoinFactorDecimal

        SVProgressHUD.showProgress(0.5)
        DispatchQueue.global().async {
            self.getNonce(completion: { nonce in

                guard let nonce = nonce else {
                    SVProgressHUD.showError(withStatus: "Can't get nonce")
                    return
                }

                let tx = DeclareCandidacyRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", address: Session.shared.address, publicKey: publicKey, commission: BigUInt(decimal: commission)!, coin: coin, stake: BigUInt(decimal: stake)!)

                let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())

                TransactionManager.default.send(tx: "Mt" + signed!) { res, _, error in

                    DispatchQueue.main.async {
                        if error == nil {
                            SVProgressHUD.showSuccess(withStatus: res ?? "Done")
                        } else {
                            SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
                        }
                    }
                }
            })
        }
    }

    @IBAction func didTapTurnOnButton(_: Any) {
        SVProgressHUD.showProgress(0.5)

        DispatchQueue.global().async {
            self.getNonce(completion: { nonce in

                guard let nonce = nonce else {
                    SVProgressHUD.showError(withStatus: "Can't get nonce")
                    return
                }
                let tx = SetCandidateOnlineRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", publicKey: self.publicKeyTextField.text ?? "")
                let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())

                TransactionManager.default.send(tx: "Mt" + signed!) { res, _, error in
                    DispatchQueue.main.async {
                        if error == nil {
                            SVProgressHUD.showSuccess(withStatus: res ?? "Done")
                        } else {
                            SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
                        }
                    }
                }
            })
        }
    }

    @IBAction func didTapTurnOff(_: Any) {
        let publicKey = publicKeyTextField.text ?? ""

        SVProgressHUD.showProgress(0.5)
        DispatchQueue.global().async {
            self.getNonce(completion: { nonce in

                guard let nonce = nonce else {
                    SVProgressHUD.showError(withStatus: "Can't get nonce")
                    return
                }

                let tx = SetCandidateOfflineRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", publicKey: publicKey)
                let signed = RawTransactionSigner.sign(rawTx: tx, privateKey: Session.shared.privateKey!.raw.toHexString())

                TransactionManager.default.send(tx: "Mt" + signed!) { res, _, error in
                    DispatchQueue.main.async {
                        if error == nil {
                            SVProgressHUD.showSuccess(withStatus: res ?? "Done")
                        } else {
                            SVProgressHUD.showError(withStatus: (error as? HTTPClientError)?.userData?.description)
                        }
                    }
                }
            })
        }
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -
}
