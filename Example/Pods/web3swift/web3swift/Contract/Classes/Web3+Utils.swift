//
//  web3utils.swift
//  web3swift
//
//  Created by Alexander Vlasov on 18.12.2017.
//  Copyright © 2017 Bankex Foundation. All rights reserved.
//

import Foundation
import BigInt

extension Web3 {
    public struct Utils{
    }
}

extension Web3.Utils {
    public enum Units {
        case eth
        case wei
        
        var decimals:Int {
            get {
                switch self {
                case .eth:
                    return 18
                case .wei:
                    return 0
                default:
                    return 18
                }
            }
        }
    }
}

extension Web3.Utils {
    
    public static func privateToPublic(_ privateKey: Data, compressed: Bool = false) -> Data? {
        guard let publicKey = SECP256K1.privateToPublic(privateKey:  privateKey, compressed: compressed) else {return nil}
        return publicKey
    }
    
    public static func publicToAddressData(_ publicKey: Data) -> Data? {
        if publicKey.count == 33 {
            guard let decompressedKey = SECP256K1.combineSerializedPublicKeys(keys: [publicKey], outputCompressed: false) else {return nil}
            return publicToAddressData(decompressedKey)
        }
        var stipped = publicKey
        if (stipped.count == 65) {
            if (stipped[0] != 4) {
                return nil
            }
            stipped = stipped[1...64]
        }
        if (stipped.count != 64) {
            return nil
        }
        let sha3 = stipped.sha3(.keccak256)
        let addressData = sha3[12...31]
        return addressData
    }
    
    public static func publicToAddress(_ publicKey: Data) -> EthereumAddress? {
        guard let addressData = Web3.Utils.publicToAddressData(publicKey) else {return nil}
        let address = addressData.toHexString().addHexPrefix().lowercased()
        return EthereumAddress(address)
    }
    
    public static func publicToAddressString(_ publicKey: Data) -> String? {
        guard let addressData = Web3.Utils.publicToAddressData(publicKey) else {return nil}
        let address = addressData.toHexString().addHexPrefix().lowercased()
        return address
    }
    
    public static func addressDataToString(_ addressData: Data) -> String {
        return addressData.toHexString().addHexPrefix().lowercased()
    }
    
    public static func hashPersonalMessage(_ personalMessage: Data) -> Data? {
        var prefix = "\u{19}Ethereum Signed Message:\n"
        prefix += String(personalMessage.count)
        guard let prefixData = prefix.data(using: .ascii) else {return nil}
        var data = Data()
        if personalMessage.count >= prefixData.count && prefixData == personalMessage[0 ..< prefixData.count] {
            data.append(personalMessage)
        } else {
            data.append(prefixData)
            data.append(personalMessage)
        }
        let hash = data.sha3(.keccak256)
        return hash
    }
    
    public static func formatToEthereumUnits(_ bigNumber: BigInt, toUnits: Web3.Utils.Units = .eth, decimals: Int = 4) -> String? {
        let magnitude = bigNumber.magnitude
        guard let formatted = formatToEthereumUnits(magnitude, toUnits: toUnits, decimals: decimals) else {return nil}
        switch bigNumber.sign {
        case .plus:
            return formatted
        case .minus:
            return "-" + formatted
        }
    }
    
    public static func formatToEthereumUnits(_ bigNumber: BigUInt, toUnits: Web3.Utils.Units = .eth, decimals: Int = 4) -> String? {
        let unitDecimals = toUnits.decimals
        var toDecimals = decimals
        if unitDecimals < toDecimals {
            toDecimals = unitDecimals
        }
        let divisor = BigUInt(10).power(unitDecimals)
        let (quotient, remainder) = bigNumber.quotientAndRemainder(dividingBy: divisor)
        let remainderPadded = String(remainder).leftPadding(toLength: unitDecimals, withPad: "0")[0..<toDecimals]
        return String(quotient) + "." + remainderPadded
    }
}
