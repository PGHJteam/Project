//
//  SignupForm.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/04.
//

import Foundation

struct SignupForm: Codable {
    var id: String
    var password: String
    var name: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case password
        case name = "user_name"
        case email = "user_email"
    }
}
