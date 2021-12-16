//
//  History.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/27.
//

import Foundation

struct History: Codable {
    let history: [HistoryItem]
    
    func totalCount() -> Int {
        var totalCount = 0
        for item in history {
            totalCount += item.materialList.count
        }
        return totalCount
    }
    
    func totalMaterials() -> [String] {
        var totalMaterials = [String]()
        for item in history {
            totalMaterials += item.materialList
        }
        return totalMaterials
    }
}

struct HistoryItem: Codable {
    let uploadID: String
    let materialList: [String]

    enum CodingKeys: String, CodingKey {
        case uploadID = "upload_id"
        case materialList = "material_list"
    }
}
