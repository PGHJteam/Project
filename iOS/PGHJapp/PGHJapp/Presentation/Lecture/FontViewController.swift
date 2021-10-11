//
//  FontViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/12.
//

import UIKit

protocol FontViewControllerDelegate{
    func sendData(titleFont: String, bodyFont: String)
}

class FontViewController: UIViewController {
    
    var delegate: FontViewControllerDelegate?

    private var titleFont: String?
    private var bodyFont: String?

    @IBOutlet weak var titleFontButton: UIButton!
    @IBOutlet weak var bodyFontButton: UIButton!
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        delegate?.sendData(titleFont: titleFont ?? "font1", bodyFont: bodyFont ?? "font1") // default = font1
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let font1 = UIAction(title: "font1", handler: { _ in self.titleFont = "font1" })
        let font2 = UIAction(title: "font2", handler: { _ in self.titleFont = "font2" })
        titleFontButton.menu = UIMenu(children: [font1, font2])
        bodyFontButton.menu = UIMenu(children: [font1, font2])
    }
}
