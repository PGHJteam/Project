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
    func sendData(data: UploadData) {
        myData = data
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        lectureData = Lecture.make(imageData: myData!)
    }
    
    @IBAction func createButtonTouched(_ sender: Any) {
        let token = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        print("token", token)
        do {
            
            let encoder = JSONEncoder()
            let data = try encoder.encode(lectureData)
//            dump(String(data: data, encoding: .utf8))
            
        } catch {
            print("Whoops, I did it again: \(error)")
        }
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(lectureData)
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
