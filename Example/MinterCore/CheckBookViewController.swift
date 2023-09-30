//
//  CheckBookViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 18/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import BigInt
import MinterCore
import SVProgressHUD
import UIKit

class CheckBookViewController: BaseViewController {
    // MARK: - IBOutlet

    @IBOutlet var nonceTextField: UITextField!

    @IBOutlet var dueBlockTextField: UITextField!

    @IBOutlet var amountTextField: UITextField!

    @IBOutlet var coinTextField: UITextField!

    @IBOutlet var passPhraseTextField: UITextField!

    @IBOutlet var checkTextField: UITextField!

    @IBOutlet var redeemPassphraseTextField: UITextField!

    @IBAction func issueButtonDidTap(_: Any) {
        let dueBlock = dueBlockTextField.text ?? "999999"
        let amount = amountTextField.text ?? "0"
        let coin = coinTextField.text ?? "MNT"
        let passPhrase = passPhraseTextField.text ?? "pass"

        getNonce { nonce in
            guard let nonce = nonce else {
                SVProgressHUD.showError(withStatus: "Can't get nonce")
                return
            }

            let check = self.makeIssueTransaction(nonce: "nonce", dueBlock: dueBlock, amount: amount, coin: coin, passPhrase: passPhrase)
            DispatchQueue.main.async {
                if let check = check {
                    self.checkTextField.text = check
                    SVProgressHUD.showSuccess(withStatus: check)
                } else {
                    SVProgressHUD.showError(withStatus: "Can't create check")
                }
            }
        }
    }

    @IBAction func redeemButtonDidTap(_: Any) {
        let pk = Session.shared.privateKey!.raw.toHexString()

        let rawCheck = Data(hex: checkTextField.text?.stripMinterCheckHexPrefix() ?? "")

        let pubKey = RawTransactionSigner.publicKey(privateKey: Data(hex: pk), compressed: false)!.dropFirst()

        let address = RawTransactionSigner.address(privateKey: pk)!

        let proof = RawTransactionSigner.proof(address: address, passphrase: redeemPassphraseTextField.text ?? "")

        let data = RedeemCheckRawTransactionData(rawCheck: rawCheck, proof: proof!)

        let gasCoin = "MNT"

        getNonce { nonce in
            guard let nonce = nonce else {
                SVProgressHUD.showError(withStatus: "Can't get nonce")
                return
            }

            let tx = RedeemCheckRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, rawCheck: rawCheck, proof: proof!)!
            tx.data = data.encode()!

            let result = RawTransactionSigner.sign(rawTx: tx, privateKey: pk)

            TransactionManager.default.send(tx: "Mt" + result!) { _, _, err in
                guard err == nil else {
                    SVProgressHUD.showError(withStatus: err.debugDescription ?? "")
                    return
                }
                SVProgressHUD.showError(withStatus: "Check has been redeemed")
            }
        }
    }

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -

    func makeIssueTransaction(nonce: String, dueBlock: String = "999999", amount: String, coin: String, passPhrase: String) -> String? {
        let due = BigUInt(dueBlock) ?? BigUInt(0)
        let val = BigUInt(amount) ?? BigUInt(0)

        var tx = IssueCheckRawTransaction(nonce: nonce, dueBlock: due, coin: coin, value: val, gasCoin: coin, passPhrase: passPhrase)
        let check = tx.serialize(privateKey: Session.shared.privateKey!.raw.toHexString(), passphrase: passPhrase)
        return check
    }
}
