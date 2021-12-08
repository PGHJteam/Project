//
//  DownloadViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/04.
//

import UIKit
import Alamofire

class DownloadViewController: UIViewController {
    var material: Material?
    var materialName: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressBarImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // 여기서 create/pptx 요청하기 완료되면 -> self.activityIndicator.stopAnimating()
    }
    
    private func configure() {
        progressBarImageView.addShadowToUnder()
        activityIndicator.startAnimating()
    }
    
    @IBAction func downloadButtonTouched(_ sender: Any) {
        let materialName = UserDefaults.standard.string(forKey: "materialName")
        let fileManager = FileManager.default
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = materialName ?? "sample.pptx"
        let fileURL = appURL.appendingPathComponent(fileName)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        guard let myMaterial = material else {return}
        let materialInfo = MaterialInfo(material: myMaterial)

        AF.download(Endpoint.download, method: .post, parameters: materialInfo, encoder: JSONParameterEncoder.default,
                    headers: ["Authorization": "Bearer \(token)",
                              "Content-Type": "application/vnd.openxmlformats-officedocument.presentationml.presentation"],
                    to: destination).downloadProgress { (progress) in
        }.response{ response in
            if response.error != nil {
                print("파일다운로드 실패")
            }else{
                print("파일다운로드 완료")
                guard let downloadSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadSuccessViewController") as? DownloadSuccessViewController else { return }
                self.navigationController?.pushViewController(downloadSuccessVC, animated: true)
            }
        }

    }
    
}
