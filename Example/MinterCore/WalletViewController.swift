//
//  WalletViewController.swift
//  MinterCore_Example
//
//  Created by Alexey Sidorov on 12/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import MinterCore
import Alamofire


class WalletViewController: BaseViewController {
	
	//MARK: -
	
	@IBOutlet var get100MNTButton: UIButton!
	
	@IBOutlet weak var tableView: UITableView!
	
	@IBAction func didTapGet100MNTButton(_ sender: Any) {
		//get 100 MNT
		requestMNT(address: Session.shared.address) { (suc) in
			if suc {
				print("Got it")
			}
			else {
				print("No more Coins this hour")
			}
			
			self.reloadData()
			
		}
	}
	
	//MARK: -
	
	var cells: [(String, [String])] = [("Address", [Session.shared.address])]
	
	let accountManager = AccountManager.default
	
	let transactionManager = TransactionManager.default
	
	var timer = Timer()
	
	//MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.tableFooterView = get100MNTButton
		
//		reloadData()
		
		if #available(iOS 10.0, *) {
			
			timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: true)
			timer.fire()
		} else {
			reloadData()
		}
		
	}
	
	@objc func reloadData() {

		let address = Session.shared.address
		
		accountManager.address(address) { [weak self] (resp, error) in
			
			var coins = [String]()
			if let balances = resp?["balance"] as? [String : String] {
				for balance in balances.keys {
					let amount = (Decimal(string: balances[balance] ?? "0") ?? Decimal(0)) / TransactionCoinFactorDecimal
					coins.append(balance + " " + "\(amount)")
				}
			}
			
			DispatchQueue.main.async {
				self?.cells.removeAll()
				self?.cells.append(("Address", [address]))
				self?.cells.append(("Coins", coins))
				self?.tableView.reloadData()
			}
		}
	}
	
	func requestMNT(address: String, completion: ((Bool) -> ())?) {
		
		Alamofire.request("https://minter-bot-wallet.dl-dev.ru/api/coins/send", method: .post, parameters: ["address" : address]).responseJSON { (response) in
			if response.response?.statusCode == 200 {
				completion?(true)
			}
			else {
				completion?(false)
			}
		}
	}

}

extension WalletViewController : UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let section = cells[section].0
		return section
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellItem = cells[indexPath.section].1[indexPath.row]
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
		cell?.textLabel?.text = cellItem
		cell?.textLabel?.numberOfLines = 0
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = cells[section].1
		
		return section.count
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return cells.count
	}
	
}
