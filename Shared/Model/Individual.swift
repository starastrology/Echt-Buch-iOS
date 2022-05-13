//
//  Individual.swift
//  EchtBuch
//
//  Created by Daniel Frecka on 4/3/22.
//

import Foundation

struct Individual: Codable {
    var id: Int
    let firstName, lastName: String
    let user: User
    let dob: String
    let placeOfBirth: PlaceOfBirth
    let lastSeen: LastSeen?
    let gender: String
    let sunSign, moonSign, risingSign, mercurySign: Sign
    let venusSign, marsSign, jupiterSign: Sign
    let profilePic: String?
    let compatibility : Double?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case user
        case dob
        case placeOfBirth = "place_of_birth"
        case lastSeen = "last_seen"
        case gender
        case sunSign = "sun_sign"
        case moonSign = "moon_sign"
        case risingSign = "rising_sign"
        case mercurySign = "mercury_sign"
        case venusSign = "venus_sign"
        case marsSign = "mars_sign"
        case jupiterSign = "jupiter_sign"
        case profilePic = "profile_pic"
        case compatibility = "compatibility_REST"
    }
}

// MARK: - Sign
struct Sign: Codable {
    let value: Int
    let sign: String
    let htmlCode: String
    let unicodeValue: String
    
    enum CodingKeys: String, CodingKey {
        case value, sign
        case htmlCode = "html_code"
        case unicodeValue = "unicode_value"
    }
}

// MARK: - PlaceOfBirth
struct PlaceOfBirth: Codable {
    let latitude, longitude, name: String
}
struct LastSeen: Codable {
    let latitude, longitude, name: String
}
struct User: Codable {
    let username: String
}

