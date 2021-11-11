//
//  Image.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Image: Codable {
    let id: Int
    let results: [Text]
    enum CodingKeys: String, CodingKey {
        case id = "image_id"
        case results
    }
}
