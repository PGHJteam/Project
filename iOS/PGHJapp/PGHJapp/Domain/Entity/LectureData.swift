//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import Foundation

struct Font: Codable {
    var size: Int
    var type: String
}

struct Sentence: Codable {
    var sentence: String
    var coordinate: Coordinate
    var size: Size
    var font: Font
}

struct Item: Codable {
    let page: Int
    var sentences: [Sentence]
}

struct LectureData: Codable {
    let uploadID: Int
    let templateID: String
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case uploadID = "upload_id"
        case templateID = "template_id"
        case items
    }
}

struct Lecture {
    static func make(imageData: UploadData) -> LectureData {
        let upload_id = imageData.id
        let template_id = "template01-01"
        var items = [Item]()
        let font = Font(size: 20, type: "bold")
        for image in imageData.images {
            var sentences = [Sentence]()
            for text in image.results {
                let t = Sentence(sentence: text.text, coordinate: text.coordinate, size: text.size, font: font)
                sentences.append(t)
            }
            let item = Item(page: image.id, sentences: sentences)
            items.append(item)
        }
        return LectureData(uploadID: upload_id, templateID: template_id, items: items)
    }
}
