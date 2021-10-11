//
//  LectureViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/09.
//

import UIKit
import Alamofire

class LectureViewController: UIViewController, SendDataDelegate {
    var myData: UploadData?
    var lectureData: LectureData?
    @IBOutlet weak var createButton: UIButton!
    func sendData(data: UploadData) {
        myData = data
    }
    @IBAction func languageTypeButtonTouched(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        lectureData = Lecture.make(imageData: myData!)
    }
    
    private func configure() {
        createButton.layer.cornerRadius = 5
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(Endpoint.createRequest, method: .post, parameters: lectureData, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"])
            .responseDecodable(of: Material.self) { response in
                print(response)
                switch response.result {
                case .success(let material):
                    guard let downloadVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadViewController") as? DownloadViewController else { return }
                    downloadVC.material = material
                    self.navigationController?.pushViewController(downloadVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
