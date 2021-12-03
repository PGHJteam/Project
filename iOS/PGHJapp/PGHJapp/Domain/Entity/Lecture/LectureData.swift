//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import Foundation

struct LectureData: Codable {
    let uploadID: Int
    let templateID: String
    let materialName: String
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case uploadID = "upload_id"
        case templateID = "template_id"
        case materialName = "material_name"
        case items
    }
}


