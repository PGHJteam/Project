//
//  TemplateViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/11.
//

import UIKit

class TemplateViewController: UIViewController {
    
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "template01-01.png")
    }
    
    @IBAction func selectButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
