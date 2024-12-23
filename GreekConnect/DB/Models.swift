//
//  EventModel.swift
//  GreekConnect
//
//  Created by Hayden Romick on 12/2/24.
//

import Foundation

struct User: Codable, Equatable {
    struct Name: Codable, Equatable {
        var first: String
        var middle: String?
        let last: String
    }
    
    var name: Name
    var pledgeClass: String
    let email: String
    var company: String
    var role: String
    var status: String
}

struct Event: Codable {
    let date: Date
    let location: Location
    let details: String
}

struct Location: Codable, Equatable {
    var address: String
    var city: String
    var country: String
    var state: String
    var zipCode: String
}

