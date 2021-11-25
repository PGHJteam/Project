//
//  LoginViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/22.
//

import UIKit
import Alamofire // 나중에 지우기
class SigninViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        usernameTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        let user = SigninForm(id: username, password: password)
                
        AF.request(Endpoint.signin, method: .post, parameters: user)
            .responseDecodable(of: Token.self)  { response in
                print(response)
                switch response.result {
                case .success(let token):
                    print(token)
                    UserDefaults.standard.set(token.refresh, forKey: "refreshToken")
                    UserDefaults.standard.set(token.access, forKey: "accessToken")
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
                    self.navigationController?.pushViewController(homeVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
