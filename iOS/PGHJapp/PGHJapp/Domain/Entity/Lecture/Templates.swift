//
//  Templates.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/06.
//

import Foundation

struct Templates {
    static let list: [Int] = [8,6,4,7,11]
    static let totalNumber = list.reduce(0, +)
    static func getID(number: Int) -> String {
        var type = 1
        var color = 1
        var sum = 0
        for (i, e) in list.enumerated() {
            let temp = sum
            sum += e
            if number+1 <= sum {
                type = i+1
                color = number+1 - temp
                break
            }
        }
        return String(format: "template%02d-%02d", type, color)
    }
}
