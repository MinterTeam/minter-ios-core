//
//  Coin.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 22/02/2018.
//

import Foundation
import ObjectMapper

/// Coin Model
public class Coin {
  // Coin identifier
  public var id: Int?

  /// Coin name (e.g. Belt Coin)
  public var name: String?

  /// Coin symbol (e.g. BELTCOIN)
  public var symbol: String?

  /// Coin volume value (e.g. 1000000000000000000000)
  public var volume: String?

  /// Coin Reserve Ratio (e.g. 10)
  public var crr: String?

  /// Reserve Balance (e.g. 10000000000000000000)
  public var reserveBalance: Decimal?

  //max supply 1,000,000,000,000,000
  public var maxSupply: Decimal?

  /// Creator`s address (e.g. Mx8aecc99090e22db1ae017a739b0dc0beb63dbee8)
  public var ownerAddress: String?

  public var isOracleVerified: Bool = false
}

/// Internal use Coin mappable class
public class CoinMappable: Coin, Mappable {

  /**
  Coin Model Initializer
  - Parameters:
  - map: Map object to initialize from
  - Returns: CoinMappable instance
  */
  public required init?(map: Map) {
    super.init()

    self.mapping(map: map)
  }

  // MARK: - ObjectMapper

  public func mapping(map: Map) {
    self.id <- map["id"]
    if let idStr = map.JSON["id"] as? String, self.id == nil {
        self.id = Int(idStr)
    }
    self.name <- map["name"]
    self.symbol <- map["symbol"]
    self.volume <- map["volume"]
    self.crr <- map["crr"]
    self.reserveBalance <- (map["reserve_balance"], DecimalTransformer())
    self.maxSupply <- (map["max_supply"], DecimalTransformer())
    self.ownerAddress <- map["owner_address"]
  }
}

public extension Coin {

  /// Base coin model, differs depend on the network (testnet, mainnet)
  /// To be removed in next versions. Please see Commissions endpoind for base coin
  static func baseCoin() -> Coin {
    let coin = Coin()
    coin.id = 0
    if MinterCoreSDK.shared.network == .testnet {
      coin.name = "MNT"
      coin.symbol = "MNT"
    } else {
      coin.name = "BIP"
      coin.symbol = "BIP"
    }
    return coin
  }
}
