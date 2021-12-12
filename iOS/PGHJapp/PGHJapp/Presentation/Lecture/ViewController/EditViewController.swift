//
//  TextViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import UIKit
import Alamofire
import SnapKit

protocol EditDelegate {
    func sendEditedLecture(lecture: Lecture?)
}

class EditViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageID: Int?
    var lecture: Lecture?
    var page: Page?
    var delegate: EditDelegate?
    private var fontSize: Int?
    private var startPoint: CGPoint?
    private var templateSize: CGSize?
    @IBOutlet weak var templateImageView: UIImageView!
    @IBOutlet weak var fontSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        configure()
        configureCoordinates()
        
//        guard let pageID = pageID else { return }
//        guard let lecture = lecture else { return }
//        self.page = lecture.getPage(id: pageID)
//        print(page)
//        let editedPage = Page(id: pageID, sentences: [Sentence(sentence: "changed", coordinate: Coordinate(left: 0.34, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic"))])
//        self.page = editedPage
//        self.lecture?.editPage(id: pageID, page: page!)
    }
    
    private func configure() {
        guard let lecture = lecture else { return }
        configureBackground(templateID: lecture.templateID)
    }
    
    private func configureBackground(templateID: String?) {
        let templateID = templateID ?? "" + ".png"
        templateImageView.image = UIImage(named: templateID)
    }
    
    private func configureCoordinates() {
        startPoint = CGPoint(x: 40.0, y: (navigationController?.navigationBar.bounds.height)!)
        let height = view.bounds.width - (navigationController?.navigationBar.bounds.height)! - 10.0
        let width = height * 16/9
        templateSize = CGSize(width: width, height: height)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        delegate?.sendEditedLecture(lecture: lecture)
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
