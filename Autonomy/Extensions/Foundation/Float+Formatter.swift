//
//  Float+Formatter.swift
//  Autonomy
//
//  Created by Thuyen Truong on 5/4/20.
//  Copyright © 2020 Bitmark Inc. All rights reserved.
//

import Foundation

extension Float {
    var formatInt: String {
        return "\(Int(self.rounded()))"
    }

    var roundInt: Int {
        return Int(self.rounded())
    }

    var formatPercent: String {
        if self < 0.01 && self > 0 {
            return "0.01"
        }
        return String(format: "%.2f", self)
    }

    var formatRatingScore: String {
        return String(format: "%.1f", self)
    }

    var formatDistance: String {
        let distanceStr = String(format: "%.1f", self)
        return R.string.localizable.distanceKm("\(distanceStr)")
    }

    var simple: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .decimal

        return formatter.string(from: self as NSNumber) ?? ""
    }
}

extension Int {
    var formatNumber: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }

    var polish: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
