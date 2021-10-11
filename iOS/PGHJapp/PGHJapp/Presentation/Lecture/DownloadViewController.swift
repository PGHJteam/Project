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
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func downloadButtonTouched(_ sender: Any) {
        activityIndicator.startAnimating()
        let fileManager = FileManager.default
        let data = MaterialInfo(path: material!.path, name: material!.name)
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentsURL = URL(fileURLWithPath: documentsPath, isDirectory: true)
            let fileURL = documentsURL.appendingPathComponent("\(self.material!.id).pptx")

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print(data)
        let encodedData = try! JSONEncoder().encode(data)
        print(encodedData)
//        AF.request(Endpoint.download, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"])
//            .responseJSON { response in
//                print(response)
//            }
        AF.download(Endpoint.download, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(token)"], to: destination)
            .response { response in
                print(destination)

                switch response.result {
                case.success(let success):
                    self.activityIndicator.stopAnimating()
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                case .failure(let error):
                    print(error)

                }
            }
    }
    
}
