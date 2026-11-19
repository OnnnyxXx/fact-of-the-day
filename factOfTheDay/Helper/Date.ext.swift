//
//  Date.swift
//  historyFact
//
//  Created by ivan on 18.11.2026.
//

import Foundation

extension Date{
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = .init(identifier: "EN_en")
        return formatter.string(from: self)
    }
}
