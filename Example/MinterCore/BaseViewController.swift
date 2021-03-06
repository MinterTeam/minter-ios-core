//
//  BaseViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 08/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import BigInt

class BaseViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func getNonce(completion: ((BigUInt?) -> ())?) {
		AccountManager.default.address(Session.shared.address, with: { (data, err) in
			
			guard let nonceString = data?["transaction_count"] as? String else {
				return
			}
			let nonce = (BigUInt(nonceString)! + BigUInt(1))
			completion?(nonce)
		})
	}

}
