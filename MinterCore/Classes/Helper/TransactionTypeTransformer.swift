//
//  TransactionTypeTransformer.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 06/03/2019.
//

import Foundation
import ObjectMapper

/// TransactionTypeTransformer class
public class TransactionTypeTransformer: TransformType {
    public init() {}

    public typealias Object = TransactionType

    public typealias JSON = Int

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let val = value as? Int {
            return TransactionType(rawValue: val)
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return value?.rawValue
    }
}
