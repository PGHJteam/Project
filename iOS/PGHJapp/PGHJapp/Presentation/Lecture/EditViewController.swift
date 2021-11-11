//
//  TextViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import UIKit

class EditViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var templateID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        configureBackground(template: templateID)
    }
    
    func configureBackground(template: String?) {
        let background = UIImage(named: template ?? "template01-1")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
}

extension EditViewController {
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.sholdSupportLandscapeRight = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.sholdSupportLandscapeRight = false
    }
}
