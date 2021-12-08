//
//  TextViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import UIKit
import Alamofire

class EditViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lecture: Lecture?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
//        configureBackground(template: templateID)
    }
    
    func configureBackground(template: String?) {
        let background = UIImage(named: lecture!.templateID)
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // 저장 button click시 create 요청
    //crete 요청
    //        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
    //
    //        AF.request(Endpoint.createRequest, method: .post, parameters: lecture, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"])
    //            .responseDecodable(of: Material.self) { response in
    //                print(response)
    //                switch response.result {
    //                case .success(let material):
    //                    guard let downloadVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadViewController") as? DownloadViewController else { return }
    //                    downloadVC.material = material
    //                    self.navigationController?.pushViewController(downloadVC, animated: true)
    //                case .failure(let error):
    //                    print(error)
    //                }
    //            }
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
