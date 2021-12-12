//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Page: Codable {
    let id: Int
    var sentences: [Sentence]
    
    enum CodingKeys: String, CodingKey {
        case id = "page"
        case sentences
    }
    
    mutating func changeFont(font: Font) {
        (0..<sentences.count).forEach {
            sentences[$0].changeFont(font: font)
        }
    }
}
