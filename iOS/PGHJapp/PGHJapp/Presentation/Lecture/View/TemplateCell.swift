//
//  TemplateCell.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/06.
//

import UIKit

class TemplateCell: UICollectionViewCell {
    static let id = "TemplateCell"
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(templateID: String) {
        let templateName = templateID + ".png"
        imageView.image = UIImage(named: templateName)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(named: "lightOrange")
            } else {
                backgroundColor = .systemBackground
            }
        }
    }
}
