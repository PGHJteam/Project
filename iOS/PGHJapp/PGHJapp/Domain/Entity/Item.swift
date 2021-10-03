//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import Foundation

struct Coordinates: Codable {
    var x: Int
    var y: Int
}

struct Item: Codable {
    var text: String
    var coordinates: Coordinates
}

struct Temp: Codable {
    var template_id: Int
    var items: [Item]
}
