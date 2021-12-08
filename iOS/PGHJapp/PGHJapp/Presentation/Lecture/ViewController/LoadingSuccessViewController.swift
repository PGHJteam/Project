//
//  LoadingSuccessViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/08.
//

import UIKit

class LoadingSuccessViewController: UIViewController {
    var imageData: UploadData?
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        nextButton.addShadowToUnder()
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        // lectureView로 넘어가기
        guard let lectureVC = self.storyboard?.instantiateViewController(withIdentifier: "LectureViewController") as? LectureViewController else { return }
        lectureVC.imageData = imageData
        self.navigationController?.pushViewController(lectureVC, animated: true)
    }
}
