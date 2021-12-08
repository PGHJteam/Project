//
//  materialDTO.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/09.
//

import Foundation

struct MaterialInfo: Codable {
    let path: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case path = "material_path"
        case name = "material_name"
    }
    
    init(material: Material) {
        self.path = material.path
        self.name = material.name
    }
}
