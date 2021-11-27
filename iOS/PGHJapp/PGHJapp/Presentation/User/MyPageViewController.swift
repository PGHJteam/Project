//
//  MyPageViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/26.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = UserDefaults.standard.string(forKey: "username") ?? "👻"
    }
    
    @IBAction func historyButtonTouched(_ sender: Any) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        AF.request(Endpoint.history, method: .get, headers: ["Authorization": "Bearer \(accessToken)"])
            .responseDecodable(of: History.self) { response in
                print(response)
            }
    }
    
    @IBAction func signoutButtonTouched(_ sender: Any) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        let temp = RefreshToken(refresh: refreshToken)
        AF.request(Endpoint.signout, method: .post, parameters: temp, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(accessToken)"])
            .response { response in
                switch response.result {
                case .success(_):
                    for key in UserDefaults.standard.dictionaryRepresentation().keys {
                        UserDefaults.standard.removeObject(forKey: key.description)
                    }
                    guard let signinVC = self.storyboard?.instantiateViewController(withIdentifier: "signinViewController") as? SigninViewController else { return }
                    self.navigationController?.pushViewController(signinVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
    @IBAction func tokenRefreshButtonTouched(_ sender: Any) {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") ?? ""
        let temp = RefreshToken(refresh: refreshToken)
        
        print(accessToken)
        AF.request(Endpoint.tokenRefresh, method: .post, parameters: temp, encoder: JSONParameterEncoder.default, headers: ["Authorization": "Bearer \(accessToken)"])
            .responseDecodable(of: Token.self) { response in
                switch response.result {
                case .success(let token):
                    UserDefaults.standard.set(token.refresh, forKey: "refreshToken")
                    UserDefaults.standard.set(token.access, forKey: "accessToken")
                case .failure(let error):
                    print(error)
                }
            }
    }
}
