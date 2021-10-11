//
//  LoadingViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/11.
//

import UIKit
import Alamofire

class LoadingViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var images: [UIImage]?
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        self.tabBarController?.tabBar.isHidden = true
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("eng-htr".utf8), withName: "image_type")
            if let images = self.images {
                for (index, image) in images.enumerated() {
                    let imageData = image.pngData()!
                    print(imageData)
                    multipartFormData.append(imageData, withName: "image\(index)", fileName: "image\(index).png")}
            }
            
        }, to: Endpoint.uploadImage, method: .post, headers: ["Authorization": "Bearer \(token)"])
            .responseDecodable(of: UploadData.self) { response in
                print(response)
                switch response.result {
                case .success(let imageData):
                    guard let lectureVC = self.storyboard?.instantiateViewController(withIdentifier: "LectureViewController") as? LectureViewController else { return }
                    lectureVC.myData = imageData

                    self.navigationController?.pushViewController(lectureVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        activityIndicator.stopAnimating()
    }
}
