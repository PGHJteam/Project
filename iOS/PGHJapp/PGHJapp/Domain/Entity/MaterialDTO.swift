//
//  materialDTO.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/09.
//

import Foundation

struct Material: Codable {
    let id: Int
    let path: String
    let name: String
    let template: String
    enum CodingKeys: String, CodingKey {
        case id = "upload"
        case path = "material_path"
        case name = "material_name"
        case template = "material_template"
    }
}

struct MaterialInfo: Codable {
    let path: String
    let name: String
    enum CodingKeys: String, CodingKey {
        case path = "material_path"
        case name = "material_name"
    }
}
