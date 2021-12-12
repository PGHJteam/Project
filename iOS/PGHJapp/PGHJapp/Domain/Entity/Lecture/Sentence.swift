//
//  Sentence.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Sentence: Codable {
    var sentence: String
    var coordinate: Coordinate
    var size: Size
    var font: Font
    
    mutating func changeFont(font: Font) {
        self.font = font
    }
}
