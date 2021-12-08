//
//  FontViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/12.
//

import UIKit
import Alamofire

class FontViewController: UIViewController {
    var lecture: Lecture?
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
        configureFont()
        progressBarImageView.addShadowToUnder()
    }
    
    private func configureFont() {
        fontStyleButton.setTitle(fontStyle, for: .normal)
    }
    
    @IBAction func stepperTouched(_ sender: UIStepper) { // min:10, max:40
        fontSize = Int(sender.value)
        fontSizeLabel.text = fontSize.description
        previewLabel.font = previewLabel.font.withSize(CGFloat(sender.value))
    }
    
    @IBAction func EditButtonTouched(_ sender: Any) {
        let font = Font(size: fontSize, type: fontStyle)
        lecture?.fetchFont(font: font)
        guard let pageListVC = self.storyboard?.instantiateViewController(withIdentifier: "PageListViewController") as? PageListViewController else { return }
//        pageListVC.lecture = lecture
        self.navigationController?.pushViewController(pageListVC, animated: true)
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
        configureFont()
    }
}

