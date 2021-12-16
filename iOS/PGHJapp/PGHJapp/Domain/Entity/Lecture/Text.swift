//
//  Text.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Text: Codable {
    var text: String
    var coordinate: Coordinate
    var size: Size
    let accuracy: Double
}
