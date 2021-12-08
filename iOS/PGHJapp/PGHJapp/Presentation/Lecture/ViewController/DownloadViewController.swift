//
//  DownloadViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/04.
//

import UIKit
import Alamofire

class DownloadViewController: UIViewController {
    var lecture: Lecture?
    var material: Material?
    var materialName: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressBarImageView: UIImageView!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createLecture()
    }
    
    private func configure() {
        progressBarImageView.addShadowToUnder()
        downloadButton.isHidden = true
    }
    
    private func createLecture() {
        activityIndicator.startAnimating()
        guard let lecture = lecture else { return }
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(Endpoint.createRequest, method: .post, parameters: lecture, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"])
            .responseDecodable(of: Material.self) { response in
                print(response)
                switch response.result {
                case .success(let material):
                    self.material = material
                    self.activityIndicator.stopAnimating()
                    self.downloadButton.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    @IBAction func downloadButtonTouched(_ sender: Any) {
        let fileManager = FileManager.default
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let materialName = UserDefaults.standard.string(forKey: "materialName")
        let fileName = materialName ?? "sample.pptx"
        let fileURL = appURL.appendingPathComponent(fileName)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        guard let material = material else {return}
        let materialInfo = MaterialInfo(material: material)

        AF.download(Endpoint.download, method: .post, parameters: materialInfo, encoder: JSONParameterEncoder.default,
                    headers: ["Authorization": "Bearer \(token)",
                              "Content-Type": "application/vnd.openxmlformats-officedocument.presentationml.presentation"],
                    to: destination).downloadProgress { (progress) in
        }.response{ response in
            if response.error != nil {
                print("파일다운로드 실패")
            }else{
                guard let downloadSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadSuccessViewController") as? DownloadSuccessViewController else { return }
                self.navigationController?.pushViewController(downloadSuccessVC, animated: true)
            }
        }

    }
    
}
