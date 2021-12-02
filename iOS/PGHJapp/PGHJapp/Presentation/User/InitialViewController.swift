//
//  InitialViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/25.
//

import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProgressView()
        progressButton.addShadowToUnder()
    }
    
    private func configureProgressView() {
        progressView.progressViewStyle = .bar
        progressView.transform = progressView.transform.scaledBy(x: 1, y: 3)
        progressView.progressTintColor = .white
        progressView.trackTintColor = UIColor(named: "progressBarWhite")
        progressView.progress = 0.5
    }
    
//    @IBAction func swipeHandler(_ gestureRecognizer : UISwipeGestureRecognizer) {
//        if gestureRecognizer.direction == .left {
//            progressView.progress = 1.0
//        }
//    }
}
