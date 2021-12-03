//
//  Lecture.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Lecture {
    static func make(imageData: UploadData, materialName: String, templateID: String, fontSize: Int, fontType: String) -> LectureData {
        let uploadID = imageData.id
        let templateID = templateID
        let materialName = materialName
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
        return LectureData(uploadID: uploadID, templateID: templateID, materialName: materialName, items: items)
    }
}
