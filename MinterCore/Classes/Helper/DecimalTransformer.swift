//
//  DecimalTransformer.swift
//  MinterCore
//
//  Created by Alexey Sidorov on 21/03/2019.
//

import Foundation
import ObjectMapper

/// DecimalTransformer class
public class DecimalTransformer: TransformType {
    static let stringFormatters: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()

    // MARK: -

    public init() {}

    public typealias Object = Decimal

    public typealias JSON = String

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let val = value as? String {
            return Decimal(string: val)
        }
        return nil
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        return DecimalTransformer.stringFormatters.string(for: value ?? 0.0)
    }
}
