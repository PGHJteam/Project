//
//  Lecture.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/11.
//

import Foundation

struct Lecture {
    static func make(imageData: UploadData) -> LectureData {
        let upload_id = imageData.id
        let template_id = "template01-01"
        let fileName = "sample.pptx"
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
        return LectureData(uploadID: upload_id, templateID: template_id, fileName: fileName, items: items)
    }
}
