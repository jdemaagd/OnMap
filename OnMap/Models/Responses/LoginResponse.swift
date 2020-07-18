//
//  LoginResponse.swift
//  OnMap
//
//  Created by JON DEMAAGD on 6/28/20.
//  Copyright © 2020 JON DEMAAGD. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}
