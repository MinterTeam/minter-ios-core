//
//  Manager+Default.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 20/02/2018.
//

import Foundation

public extension String {
    func stripMinterHexPrefix() -> String {
        return replacingOccurrences(of: "^(Mx|mx|MX|mX|Mt|mt|MT|mT|Mp|mp|MP|mP)", with: "", options: .regularExpression)
    }

    func stripMinterCheckHexPrefix() -> String {
        return replacingOccurrences(of: "^(Mc|mc|MC|mC)", with: "", options: .regularExpression)
    }
}
