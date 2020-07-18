//
//  Location.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/30/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

struct Location: Codable {
    let createdAt: String
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String
    let uniqueKey: String?
    let updatedAt: String
    
    var locationLabel: String {
        var name = ""
        if let firstName = firstName {
            name = firstName
        }
        if let lastName = lastName {
            if name.isEmpty {
                name = lastName
            } else {
                name += " \(lastName)"
            }
        }
        if name.isEmpty {
            name = "FirstName LastName"
        }
        return name
    }
}
