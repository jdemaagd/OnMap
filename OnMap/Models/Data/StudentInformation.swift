//
//  StudentInformation.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

struct StudentInformation: Codable {
    let createdAt: String?
    let firstName: String
    let lastName: String
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    
    init(_ dictionary: [String: AnyObject]) {
        self.createdAt = dictionary["createdAt"] as? String
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String
    }
    
    var labelName: String {
        var name = ""
        if !firstName.isEmpty {
            name = firstName
        }
        if !lastName.isEmpty {
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
