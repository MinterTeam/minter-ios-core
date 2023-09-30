//
//  Double+Round.swift
//  MinterExplorer
//
//  Created by Alexey Sidorov on 04/07/2018.
//

import Foundation

public extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
