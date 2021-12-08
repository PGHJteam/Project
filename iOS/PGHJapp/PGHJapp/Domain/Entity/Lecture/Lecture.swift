//
//  Item.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import Foundation

struct Lecture: Codable {
    var uploadID: Int
    let name: String
    let templateID: String
    var items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case uploadID = "upload"
        case templateID = "template_id"
        case name = "material_name"
        case items
    }
    
    init(name: String, templateID: String) {
        self.uploadID = 0
        self.name = name + ".pptx"
        self.templateID = templateID
        self.items = [Item]()
    }
    
    init(uploadID: Int, name: String, templateID: String, items: [Item]) {
        self.uploadID = uploadID
        self.name = name
        self.templateID = templateID
        self.items = items
    }
    
    mutating func fetchImageData(imageData: UploadData, font: Font) {
        self.uploadID = imageData.id
        for image in imageData.images {
            var sentences = [Sentence]()
            for result in image.results {
                let sentence = Sentence(sentence: result.text, coordinate: result.coordinate, size: result.size, font: font)
                sentences.append(sentence)
            }
            var item = Item(page: image.id, sentences: sentences)
            self.items.append(item)
        }
    }
    
    mutating func fetchFont(font: Font) {
        (0..<items.count).forEach { 
            items[$0].changeFont(font: font)
        }
    }
    
    static func make(imageData: UploadData, name: String, templateID: String, fontSize: Int, fontType: String) -> Lecture {
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
        return Lecture(uploadID: uploadID, name: name, templateID: templateID, items: items)
    }
}


