//
//  TextType.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/11.
//

import Foundation

enum LanguageType: CustomStringConvertible {
    case englishPrinting
    case englishHandwritting
    case koreanPrinting
    case koreanHandwritting
    case mathPrinting
    case mathHandwriting
    
    var description: String{
        switch self {
        case .englishPrinting:
            return "eng-ocr"
        case .englishHandwritting:
            return "eng-htr"
        case .koreanPrinting:
            return "kor-ocr"
        case .koreanHandwritting:
            return "kor-htr"
        case .mathPrinting:
            return "math-ocr"
        case .mathHandwriting:
            return "math-htr"
        }
    }
}
