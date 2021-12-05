//
//  FontViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/12.
//

import UIKit

class FontViewController: UIViewController {
    private var fontSize: Int = 10
    private var fontStyle: String = "NanumBarunGothic"
    @IBOutlet weak var fontStyleButton: UIButton!
    
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var progressBarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        previewLabel.font = UIFont(name: fontStyle, size: CGFloat(fontSize))
        fontStyleButton.titleLabel?.text = fontStyle
        progressBarImageView.addShadowToUnder()
    }
    
    @IBAction func fontStyleButtonTouched(_ sender: Any) {
    }
    
    @IBAction func stepperTouched(_ sender: UIStepper) { // min:10, max:40
        fontSizeLabel.text = Int(sender.value).description
        previewLabel.font = previewLabel.font.withSize(CGFloat(sender.value))
    }
    
    @IBAction func EditButtonTouched(_ sender: Any) {
        
    }
}


