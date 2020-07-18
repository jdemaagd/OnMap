//
//  UseProfile.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
}
