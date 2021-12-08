//
//  ImageCell.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/02.
//

import UIKit

class ImageCell: UICollectionViewCell {
    static let id = "ImageCell"
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleToFill
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(image: UIImage) {
        imageView.image = image
    }
}
