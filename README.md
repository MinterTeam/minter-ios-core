<p align="center" background="black"><img src="minter-logo.svg" width="400"></p>

<p align="center">
<a href="https://github.com/MinterTeam/minter-ios-core/releases/latest"><img src="https://img.shields.io/github/tag/MinterTeam/minter-ios-core.svg" alt="Version"></a>
<a href="https://travis-ci.org/MinterTeam/minter-ios-core"><img src="http://img.shields.io/travis/MinterTeam/minter-ios-core.svg?style=flat" alt="CI Status"></a> 
<a href="http://cocoapods.org/pods/MinterCore"><img src="https://img.shields.io/cocoapods/v/MinterCore.svg?style=flat" alt="Version"></a>
<a href="http://cocoapods.org/pods/MinterCore"><img src="https://img.shields.io/cocoapods/p/MinterCore.svg?style=flat" alt="Platform"></a>
<a href="https://github.com/MinterTeam/minter-ios-core/blob/master/LICENSE"><img src="https://img.shields.io/github/license/MinterTeam/minter-ios-core.svg" alt="License"></a>
<a href="https://github.com/MinterTeam/minter-ios-core/commits/master"><img src="https://img.shields.io/github/last-commit/MinterTeam/minter-ios-core.svg" alt="Last commit"></a>
</p>

# MinterCore

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation


MinterCore is available through [CocoaPods](http://cocoapods.org). To install

it, simply add the following line to your Podfile:


```ruby

pod 'MinterCore'

```

## How-to

```swift
import MinterCore
```

**Get balance**
```swift
let accountManager = AccountManager.default
accountManager.balance(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (resp, error) in
  print("Resp: \(String(describing: resp))")
  print("Error: \(String(describing: error))")
}
```
**Get coin info**
```swift
let coinManager = CoinManager.default
coinManager.info(symbol: "SHSCOIN") { (coin, error) in
  print("Coin: \(coin)")
  print("Error: \(error)")
}
```

**Get estimate coin buy**
```swift
let transactionManager = TransactionManager.default
transactionManager.estimateCoinBuy(from: "MNT", to: "BELTCOIN", amount: Decimal(string: "10000000000000")!) { (value, commission, error) in
  print("Value: \(value)")
  print("Commission: \(commission)")
  print("Error: \(error)")
}
```

**Get estimate coin sell**
```swift
transactionManager.estimateCoinSell(from: "MNT", to: "BELTCOIN", amount: Decimal(string: "10000000000000")!) { (value, commission, error) in
  print("Value: \(value)")
  print("Commission: \(commission)")
  print("Error: \(error)")
}
```

**Get transaction**
```swift
let transactionManager = TransactionManager.default
transactionManager.transaction(hash: "Mt6e59d0ad0286c1ec3539de71eb686cad42e7c741") { (transaction, error) in
  print("Transaction: \(transaction)")
}
```

**Send transaction**
```swift
import MinterCore
import BigInt
```
```swift
/// Prepeare data
let sendData = SendCoinRawTransactionData(to: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d", value: BigUInt(decimal: 1 * TransactionCoinFactorDecimal)!, coin: "MNT").encode()
/// Make 'send' raw transaction
let rawTransaction = SendCoinRawTransaction(nonce: BigUInt(1), gasCoin: "MNT", data: sendData!)
/// Sign raw transaction with private key
let signedTx = RawTransactionSigner.sign(rawTx: rawTransaction, privateKey: "8da1c947b489399a5b07b6bd3d9bb41f7647bb01a28303431b6993a8092f0bed")!
/// Send raw transaction
transactionManager.send(tx: signedTx) { (txHash, resultText, error) in
  print(txHash)
  print(resultText)
  print(error)
}
```

**Get nonce**
```swift
transactionManager.transactionCount(address: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d") { (nonce, error) in
  print("Count: \(nonce)")
  print("Error: \(error)")
}
```

**Get candidate**
```swift
let candidateManager = CandidateManager.default
candidateManager.candidate(publicKey: "Mp740b1b0f0f4b29cb2fc73e53c8e4b34966a89a97d4e1b86903db6ca2cc1c1596") { (candidate, error) in
  print(candidate)
  print(error)
}
```

**Get validators**
```swift
let validatorManager = ValidatorManager.default
validatorManager.validators { (validators, error) in
  print(validators)
  print(error)			
}
```

**Get status**
```swift
let statusManager = StatusManager.default

statusManager.status { (status, error) in
  print(status)
  print(error)
}
```

****

## Author

sidorov.panda, ody344@gmail.com


## License


MinterCore is available under the MIT license. See the LICENSE file for more info.
