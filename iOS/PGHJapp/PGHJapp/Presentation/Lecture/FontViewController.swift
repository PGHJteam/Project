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
        fontStyleButton.setTitle(fontStyle, for: .normal)
        progressBarImageView.addShadowToUnder()
    }

    @IBAction func stepperTouched(_ sender: UIStepper) { // min:10, max:40
        fontSize = Int(sender.value)
        fontSizeLabel.text = fontSize.description
        previewLabel.font = previewLabel.font.withSize(CGFloat(sender.value))
    }
    
    @IBAction func EditButtonTouched(_ sender: Any) {
        // fontStyle,fontSize 넘기기
    }
}

extension FontViewController: FontDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFontList" {
            guard let fontListVC: FontListViewController = segue.destination as? FontListViewController else { return }
            fontListVC.delegate = self
        }
    }
    
    func sendFontStyle(name: String?) {
        guard let newFontStyle = name else {return}
        fontStyle = newFontStyle
        print(fontStyle, newFontStyle)
//        viewDidLoad()
        configure()
    }
}

