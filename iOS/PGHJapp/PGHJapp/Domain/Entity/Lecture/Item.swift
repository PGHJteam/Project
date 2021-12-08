//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Item: Codable {
    let page: Int
    var sentences: [Sentence]
    
    mutating func changeFont(font: Font) {
        (0..<sentences.count).forEach {
            sentences[$0].changeFont(font: font)
        }
    }
}
