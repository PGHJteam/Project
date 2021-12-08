//
//  TextViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import UIKit
import Alamofire

protocol EditDelegate {
    func sendEditedLecture(lecture: Lecture?)
}

class EditViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageID: Int?
    var lecture: Lecture?
    var page: Page?
    var delegate: EditDelegate?
    @IBOutlet weak var templateImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        guard var pageID = pageID else { return }
        guard var lecture = lecture else { return }
        self.page = lecture.getPage(id: pageID)
        
        let editedPage = Page(id: pageID, sentences: [Sentence(sentence: "changed", coordinate: Coordinate(left: 0.34, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic"))])
        self.page = editedPage
        self.lecture?.editPage(id: pageID, page: page!)
        configureBackground(templateID: lecture.templateID)
    }
    
    func configureBackground(templateID: String?) {
        let templateID = templateID ?? "" + ".png"
        templateImageView.image = UIImage(named: templateID)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        delegate?.sendEditedLecture(lecture: lecture)
        print(lecture)
        guard let pageListVC = self.storyboard?.instantiateViewController(withIdentifier: "PageListViewController") as? PageListViewController else { return }
//        pageListVC.lecture = lecture
//        self.navigationController?.pushViewController(pageListVC, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditViewController {
    override func viewWillAppear(_ animated: Bool) {
        appDelegate.sholdSupportLandscapeRight = true
        let orientation = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.sholdSupportLandscapeRight = false
        let orientation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientation, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
