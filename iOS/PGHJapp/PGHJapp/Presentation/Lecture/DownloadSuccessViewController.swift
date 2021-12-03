//
//  DownloadSuccessViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/03.
//

import UIKit

class DownloadSuccessViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configure() {
        let materialName = UserDefaults.standard.string(forKey: "materialName") ?? "sample.pptx"
        locationLabel.text = "나의 iPhone/자료메이커" + materialName
    }
    
    @IBAction func HomeButtonTouched(_ sender: Any) {
        let HomeVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!
        self.navigationController?.pushViewController(HomeVC, animated: true)
    }
    
}
