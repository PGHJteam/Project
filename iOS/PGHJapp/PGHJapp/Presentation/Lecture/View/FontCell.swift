//
//  FontCell.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/05.
//

import UIKit

class FontCell: UITableViewCell {
    static let id = "FontCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(named: "lightOrange")
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configure(fontName: String) {
        nameLabel.text = fontName
        previewLabel.font = UIFont(name: fontName, size: previewLabel.font.pointSize)
    }
}
