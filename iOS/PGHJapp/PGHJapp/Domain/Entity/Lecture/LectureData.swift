//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import Foundation

struct LectureData: Codable {
    let uploadID: Int
    let name: String
    let templateID: String
    
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case uploadID = "upload_id"
        case templateID = "template_id"
        case name = "material_name"
        case items
    }
    
//    init(name: ) {
//        uploadID = 0
//        templateID
//        items = [Item]()
//    }
    static func make(imageData: UploadData, name: String, templateID: String, fontSize: Int, fontType: String) -> LectureData {
        let uploadID = imageData.id
        let templateID = templateID
        let name = name
        var items = [Item]()
        let font = Font(size: fontSize, type: fontType) // fontType
        for image in imageData.images {
            var sentences = [Sentence]()
            for text in image.results {
                let t = Sentence(sentence: text.text, coordinate: text.coordinate, size: text.size, font: font)
                sentences.append(t)
            }
            let item = Item(page: image.id, sentences: sentences)
            items.append(item)
        }
        return LectureData(uploadID: uploadID, name: name, templateID: templateID, items: items)
    }
}


