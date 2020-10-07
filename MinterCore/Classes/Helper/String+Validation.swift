//
//  String+Validation.swift
//  MinterExplorer
//
//  Created by Alexey Sidorov on 16.04.2020.
//

import Foundation

extension String {

  func isValidAddress() -> Bool {
    let addressTest = NSPredicate(format: "SELF MATCHES %@", "^[a-fA-F0-9]{40}$")
    return addressTest.evaluate(with: self.stripMinterHexPrefix())
  }

  func isValidPublicKey() -> Bool {
    let publicKeyTest = NSPredicate(format: "SELF MATCHES %@", "^[a-fA-F0-9]{64}$")
    return publicKeyTest.evaluate(with: self.stripMinterHexPrefix())
  }
}
