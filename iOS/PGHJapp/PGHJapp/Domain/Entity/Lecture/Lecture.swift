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
    var pages: [Page]
    
    enum CodingKeys: String, CodingKey {
        case uploadID = "upload"
        case templateID = "template_id"
        case name = "material_name"
        case pages = "items"
    }
    
    init(name: String, templateID: String) {
        self.uploadID = 0
        self.name = name + ".pptx"
        self.templateID = templateID
        self.pages = [Page]()
    }
    
    init(uploadID: Int, name: String, templateID: String, pages: [Page]) {
        self.uploadID = uploadID
        self.name = name + ".pptx"
        self.templateID = templateID
        self.pages = pages
    }
    
    func getPage(id: Int) -> Page {
        return pages[id]
    }
    
    mutating func fetchImageData(imageData: UploadData, font: Font) {
        self.uploadID = imageData.id
        for image in imageData.images {
            var sentences = [Sentence]()
            for result in image.results {
                let sentence = Sentence(sentence: result.text, coordinate: result.coordinate, size: result.size, font: font)
                sentences.append(sentence)
            }
            let item = Page(id: image.id, sentences: sentences)
            self.pages.append(item)
        }
    }
    
    mutating func fetchFont(font: Font) {
        (0..<pages.count).forEach { 
            pages[$0].changeFont(font: font)
        }
    }
    
    mutating func editPage(id: Int, page: Page) {
        self.pages[id] = page
    }
    
//    static func make(imageData: UploadData, name: String, templateID: String, fontSize: Int, fontType: String) -> Lecture {
//        let uploadID = imageData.id
//        let templateID = templateID
//        let name = name
//        var items = [Page]()
//        let font = Font(size: fontSize, type: fontType) // fontType
//        for image in imageData.images {
//            var sentences = [Sentence]()
//            for text in image.results {
//                let t = Sentence(sentence: text.text, coordinate: text.coordinate, size: text.size, font: font)
//                sentences.append(t)
//            }
//            let item = Page(id: image.id, sentences: sentences)
//            items.append(item)
//        }
//        return Lecture(uploadID: uploadID, name: name, templateID: templateID, pages: items)
//    }
}


