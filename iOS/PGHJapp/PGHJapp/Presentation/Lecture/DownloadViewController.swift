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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: nil, message: "사용자의 Document에 저장되었습니다😎", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }

    @IBAction func downloadButtonTouched(_ sender: Any) {
        activityIndicator.startAnimating()
        
        let fileManager = FileManager.default
        let appURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "Sample.pptx"
        let fileURL = appURL.appendingPathComponent(fileName)
        let material = MaterialInfo(path: "/home/ubuntu/pghj_api_test/pghj_server/files/media/test1/6/", name: fileName)
        let destination: DownloadRequest.Destination = { _, _ in
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
//        let data = MaterialInfo(path: material!.path, name: material!.name)
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""

        AF.download(Endpoint.download, method: .post, parameters: material, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)", "Content-Type": "application/vnd.openxmlformats-officedocument.presentationml.presentation"],
                    to: destination).downloadProgress { (progress) in
            print(progress)
//            self.progressView.progress = Float(progress.fractionCompleted)
//            self.progressLabel.text = "\(Int(progress.fractionCompleted * 100))%"
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
