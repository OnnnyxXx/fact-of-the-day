//
//  FactResponse.swift
//  historyFact
//
//  Created by ivan on 19.11.2026.
//

struct FactResponse: Decodable {
    let date: String?
    let type: String?
    let count: Int?
    let events: [FactEvent]?
}

struct FactEvent: Decodable, Identifiable {
    var id: String { "\(year ?? "")-\(description ?? "")" }
    let year: String?
    let description: String?
    let wikipedia: [WikiLink]?
}

struct WikiLink: Decodable {
    let title: String?
    let url: String?
}
