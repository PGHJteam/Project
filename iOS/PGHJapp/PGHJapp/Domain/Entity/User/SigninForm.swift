//
//  User.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/22.
//

import Foundation

struct SigninForm: Codable {
    var id: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case password
    }
}
