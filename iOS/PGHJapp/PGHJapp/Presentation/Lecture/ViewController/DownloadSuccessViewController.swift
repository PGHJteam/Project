//
//  DownloadSuccessViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/03.
//

import UIKit

class DownloadSuccessViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var progressBarImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        let materialName = UserDefaults.standard.string(forKey: "materialName") ?? "sample.pptx"
        locationLabel.text = "나의 iPhone>자료메이커>" + materialName
        progressBarImageView.addShadowToUnder()
    }
    
    @IBAction func HomeButtonTouched(_ sender: Any) {
        let HomeVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
        self.navigationController?.pushViewController(HomeVC, animated: true)
    }
    
}
