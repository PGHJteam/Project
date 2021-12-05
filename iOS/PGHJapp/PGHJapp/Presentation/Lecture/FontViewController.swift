//
//  FontViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/12.
//

import UIKit

class FontViewController: UIViewController {    
    @IBOutlet weak var previewLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        previewLabel.font = previewLabel.font.withSize(30)
        previewLabel.font = UIFont(name: "CookieRun Regular", size: 10)
//        previewLabel.font = previewLabel.font.na
    }
    
    @IBAction func EditButtonTouched(_ sender: Any) {
    }
}
