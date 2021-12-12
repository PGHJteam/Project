//
//  HistoryCell.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/04.
//

import UIKit

class HistoryCell: UITableViewCell {
    static let id = "HistoryCell"
    @IBOutlet weak var historyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func configure(name: String) {
        historyLabel.text = name
    }
    
}
