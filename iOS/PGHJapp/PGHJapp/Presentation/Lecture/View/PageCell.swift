//
//  PageCell.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/08.
//

import UIKit

class PageCell: UITableViewCell {
    static let id = "PageCell"
    @IBOutlet weak var pageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor(named: "lightOrange")
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    func configure(id: Int?) {
        let id = (id ?? 0) + 1
        pageLabel.text = "페이지 " + id.description
    }

}
