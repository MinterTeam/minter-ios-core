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
## About

This is a pure Swift SDK for working with <b>Minter</b> blockchain

* [Installation](#installing)
* [Minter Api](#using-minterapi)
    - Methods:
      - [address](#address)
      - [nonce](#nonce)
      - [send](#send)
      - [status](#status)
      - [getValidators](#validators)
      - [estimateCoinBuy](#estimatecoinbuy)
      - [estimateCoinSell](#estimatecoinsell)
      - [Coin Info](#info)
      - [Block](#block)
      - [Events](#events)
      - [Transaction](#transaction)
      - [Candidate](#candidate)
      - [Candidates](#Candidates)
      - [estimateTxCommission](#estimatetxcommission)
      - [Transactions](#transactions)
  
* [Minter SDK](#using-mintersdk)
  - [Sign transaction](#sign-transaction)
    - [SendCoin](#example-3)
    - [SellCoin](#example-4)
    - [SellAllCoin](#example-5)
    - [BuyCoin](#example-6)
    - [CreateCoin](#example-7)
    - [DeclareCandidacy](#example-8)
    - [Delegate](#example-9)
    - [SetCandidateOn](#example-10)
    - [SetCandidateOff](#example-11)
    - [RedeemCheck](#example-12)
    - [Unbond](#example-13)
    - [EditCandidate](#example-15)
  - [Minter Check](#create-minter-check)
  - [Minter Wallet](#minter-wallet)

## Using MinterAPI

You can get all valid responses and full documentation at [Minter Node Api](https://minter-go-node.readthedocs.io/en/latest/api.html)

Initializing SDK

```swift
///Minter SDK initialization
import MinterCore

let nodeUrlString = "https://minter-node-1.testnet.minter.network:8841" // example of a node url

MinterCoreSDK.initialize(urlString: nodeUrlString)
```

### address

Returns coins list, balance and transaction count (for nonce) of an address.

```swift
public func address(_ address: String, height: String = "0", with completion: (([String : Any]?, Error?) -> ())?)
```

###### Example

```Swift
AccountManager.default.address("Mxfe60014a6e9ac91618f5d1cab3fd58cded61ee99", with: { (data, err) in
  //["balance": ["MNT":"10000000000"], "transaction_count":0]
})
```

### nonce

Use [address](#address) method of AccountManager to get nonce

### send

Returns the result of sending <b>signed</b> tx.

```swift
public func send(tx: String, completion: ((String?, String?, Error?) -> ())?)
```

###### Example

```swift
TransactionManager.default.send(tx: "Mt...") { (hash, statusText, error) in

}
```

### status

Returns node status info.

```swift
public func status(with completion: (([String : Any]?, Error?) -> ())?)
```

### validators

Returns list of active validators.

```swift
public func validators(height: Int, with completion: (([[String : Any]]?, Error?) -> ())?)
```

### estimateCoinBuy

Return estimate of buy coin transaction.

```swift
public func estimateCoinBuy(from: String, to: String, amount: Decimal, completion: ((Decimal?, Decimal?, Error?) -> ())?)
```

### estimateCoinSell

Return estimate of sell coin transaction.

```swift
public func estimateCoinSell(from: String, to: String, amount: Decimal, completion: ((Decimal?, Decimal?, Error?) -> ())?)
```

### coin info

Returns information about coin.
Note: this method does not return information about base coins (MNT and BIP).

```swift
public func info(symbol: String, height: String = "0", completion: ((Coin?, Error?) -> ())?)
```

### block

Returns block data at given height.

```swift
public func blocks(height: String = "0", with completion: (([String : Any]?, Error?) -> ())?)
```

### events

Returns events at given height.

```swift
public func events(height: String = "0", with completion: (([String : Any]?, Error?) -> ())?)
```

### transaction

Returns transaction info.

```swift
public func transaction(hash: String, completion: ((Transaction?, Error?) -> ())?)
```

### candidate

Returns candidate’s info by provided public_key. It will respond with 404 code if candidate is not found.

```swift
public func candidate(publicKey: String, height: String = "0", completion: (([String : Any]?, Error?) -> ())?)
```

### candidates

Returns list of candidates.

height is optional parameter.

```swift
public func candidates(height: String = "0", includeStakes: Bool = false, completion: (([[String : Any]]?, Error?) -> ())?)
```

### estimateTxCommission

Return estimate of transaction.

```swift
public func estimateCommission(for rawTx: String, height: String = "0", completion: ( (Decimal?, Error?) -> ())?)
```

### transactions

Return transactions by query.

```swift
public func transaction(query: String, completion: (([Transaction]?, Error?) -> ())?)
```

### unconfirmedTransactions

Returns unconfirmed transactions.

```swift
public func unconfirmedTransaction(limit: String = "0", completion: (([String : Any]?, Error?) -> ())?)
```

## Using MinterSDK

### Sign transaction

Returns a signed tx.

###### Example

* Sign the <b>SendCoin</b> transaction

```swift
let sendData = SendCoinRawTransactionData(to: "Mx6b6b3c763d2605b842013f84cac4d670a5cb463d", value:
BigUInt(decimal: 1 * TransactionCoinFactorDecimal)!, coin: "MNT").encode()

let rawTransaction = SendCoinRawTransaction(nonce: BigUInt(1), chainId: 2, gasCoin: "MNT", data: sendData!)

let mnemonic = "adjust correct photo fancy knee lion blur away coconut inform sun cancel"

let seed = String.seedString(mnemonic)!
let pk = PrivateKey(seed: Data(hex: seed))

guard let key = try! pk.derive(at: 44, hardened: true).derive(at: 60, hardened: true).derive(at: 0, hardened: true).derive(at: 0).derive(at: 0).raw.toHexString()

/// Signing raw transaction
let signedTx = RawTransactionSigner.sign(rawTx: rawTransaction, privateKey: key)!

/// Sending raw transaction
transactionManager.send(tx: "Mt" + signedTx) { (txHash, resultText, error) in
  print(txHash)
  print(resultText)
  print(error)
}
```

###### Example
* Sign the <b>SellCoin</b> transaction

```swift
let gasCoin = "MNT"
let nonce = BigUInt(1)
let coinFrom = "MNT"
let coinTo = "BPM"
let value = BigUInt(1)
let minimumValue = BigUInt(0)
let tx = SellCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, value: value, minimumValueToBuy: minimumValue)
```

###### Example
* Sign the <b>SellAllCoin</b> transaction

```swift
let gasCoin = "MNT"
let nonce = BigUInt(1)
let coinFrom = "MNT"
let coinTo = "BPM"
let minimumValue = BigUInt(0)
let tx = SellAllCoinsRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, minimumValueToBuy: minimumValue)
```

###### Example
* Sign the <b>BuyCoin</b> transaction

```swift
let gasCoin = "MNT"
let nonce = BigUInt(1)
let coinFrom = "MNT"
let coinTo = "BPM"
let value = BigUInt(1)
let maximumValue = BigUInt(0)
let tx = BuyCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, coinFrom: coinFrom, coinTo: coinTo, value: value, maximumValueToSell: maximumValue)
```

###### Example
* Sign the <b>CreateCoin</b> transaction

```swift
let name = "Name"
let symbol = "SYMBOL"
let amount = BigUInt(1000)
let reserve = BigUInt(300000000000000000000000)
let ratio = BigUInt(70)
let maxSupply = BigUInt(1000000000000000) 

let data = CreateCoinRawTransactionData(
  name: name,
  symbol: symbol,
  initialAmount: initialAmount,
  initialReserve: initialReserve,
  reserveRatio: reserveRatio,
  maxSupply: maxSupply
)
let tx = CreateCoinRawTransaction(nonce: nonce, chainId: 2, gasCoin: "MNT", data: data.encode()!)
```

###### Example
* Sign the <b>DeclareCandidacy</b> transaction

```swift
let nonce = BigUInt(1)
let gasCoin = "MNT"
let coin = "MNT"
let address = "Mx7633980c000139dd3bd24a3f54e06474fa941e16"
let publicKey = "Mp91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
let commission = BigUInt(1)
let stake = BigUInt(2)
let model = DeclareCandidacyRawTransaction(
  nonce: nonce,
  chainId: 2,
  gasCoin: gasCoin,
  address: address,
  publicKey: publicKey,
  commission: commission,
  coin: coin,
  stake: stake
)
```

###### Example
* Sign the <b>Delegate</b> transaction

```swift
let tx = DelegateRawTransaction(
  nonce: BigUInt(1),
  chainId: 2,
  gasCoin: "MNT",
  publicKey: "Mp91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5",
  coin: "MNT",
  value: BigUInt(1000)
)
```

###### Example
* Sign the <b>SetCandidateOn</b> transaction

```swift
let nonce = BigUInt(1)
let gasCoin = "MNT"
let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
let model = SetCandidateOnlineRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, publicKey: publicKey)
```

###### Example
* Sign the <b>SetCandidateOff</b> transaction

```swift
let nonce = BigUInt(1)
let gasCoin = "MNT"
let publicKey = "Mpeadea542b99de3b414806b362910cc518a177f8217b8452a8385a18d1687a80b"
let model = SetCandidateOfflineRawTransaction(nonce: nonce, chainId: 2, gasCoin: gasCoin, publicKey: publicKey)
```

###### Example
* Sign the <b>RedeemCheck</b> transaction

```swift
let tx = RedeemCheckRawTransaction(
  nonce: BigUInt(1),
  chainId: 2,
  gasCoin: "MNT",
  rawCheck: <Check data>,
  proof: <Proof Data>)
```

###### Example
* Sign the <b>Unbond</b> transaction

```swift
let coin = "MNT"
let publicKey = "91cab56e6c6347560224b4adaea1200335f34687766199335143a52ec28533a5"
let value = BigUInt(2)
let model = UnbondRawTransactionData(publicKey: publicKey, coin: coin, value: value)
```

###### Example
* Sign the <b>EditCandidate</b> transaction

```swift
let pk = "Mpc5b635cde82f796d1f8320efb8ec634f443e6b533a973570e4b5ea04aa44e96d"
let address1 = "Mxe7ca647d17599d3e83048830fbb2df3726a7d22c"
let address2 = "Mxa8ca647d17599d3e83048830fbb2df3726a7d215"
let model = EditCandidateRawTransaction(nonce: BigUInt(1), chainId: 2, gasCoin: "MNT", publicKey: pk, rewardAddress: address1, ownerAddress: address2)
```

### Create Minter Check

###### Example

* Create check

```swift
let nonce = "1"
let dueBlock = BigUInt(99)
let coin = "MNT"
let value = BigUInt(1)
let phrase = "123"
let tx = IssueCheckRawTransaction(nonce: nonce, dueBlock: dueBlock, coin: coin, value: value, gasCoin: coin, passPhrase: phrase)
tx.data = data.encode()!
let result = RawTransactionSigner.sign(rawTx: tx, privateKey: <Private Key>)
```

* Create proof

```swift
let proof = RawTransactionSigner.proof(address: "Mxe7ca647d17599d3e83048830fbb2df3726a7d22c", passphrase: "some pass phrase")
```

### Minter Wallet

* Generate mnemonic.

```swift
let mnemonics = String.generateMnemonicString()
```

* Get seed from mnemonic.

```swift
let res = RawTransactionSigner.seed(from: mnemonic, passphrase: "", language: .english)
```

* Get private key from seed.

```swift
let privateKey = PrivateKey(seed: Data(hex: seed))
let key = try? privateKey
  .derive(at: 44, hardened: true)
  .derive(at: 60, hardened: true)
  .derive(at: 0, hardened: true)
  .derive(at: 0)
  .derive(at: 0)
```

* Get public key from private key.

```swift
let publicKey = RawTransactionSigner.publicKey(privateKey: privateKey!.raw, compressed: false)!.dropFirst()
```

* Get Minter address from public key.

```swift
let address = RawTransactionSigner.address(publicKey: publicKey)
```

****

## Author

sidorov.panda, ody344@gmail.com


## License


MinterCore is available under the MIT license. See the LICENSE file for more info.
