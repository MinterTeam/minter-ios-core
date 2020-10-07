//
//  Validator.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 30.09.2020.
//

import Foundation
import ObjectMapper

public class Validator {
  public var publicKey: String
  public var name: String?
  public var description: String?
  public var status: Int?
  public var iconURL: URL?
  public var siteURL: URL?
  public var stake: Decimal = 0
  public var minStake: Decimal = 0
  public var commission: Int?

  public init?(publicKey: String, name: String? = nil) {
    guard publicKey.isValidPublicKey() else {
      return nil
    }
    self.name = name
    self.publicKey = publicKey
  }
}

public class ValidatorMappable: Validator, Mappable {

  public required init?(map: Map) {
    guard let pubKey = map.JSON["public_key"] as? String else { return nil }

    super.init(publicKey: pubKey)

    self.mapping(map: map)
  }

  public func mapping(map: Map) {
    iconURL <- (map["icon_url"], URLTransform())
    siteURL <- (map["site_url"], URLTransform())
    name <- map["name"]
    status <- map["status"]
  }
}
