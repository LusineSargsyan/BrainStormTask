//
//  User.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

struct UserResponse: Decodable {
    let results: [User]
}

enum Gender: String, Decodable {
    case male
    case female
    case undefined

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer() 
        let value = try container.decode(String.self)
        self = Gender(rawValue: value) ?? .undefined
    }
}

struct User: Decodable {
    let gender: Gender
    let name: Name
    let location: Location
    let email: String
    let phone: String 
    let cell: String
    let picture: Picture
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Location: Decodable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let coordinates: Coordinates
}

struct Street: Decodable {
    let name: String
    let number: Int
}

struct Coordinates: Decodable {
    let latitude: String
    let longitude: String
}

struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
