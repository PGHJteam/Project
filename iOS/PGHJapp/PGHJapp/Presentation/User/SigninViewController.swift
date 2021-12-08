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
                
        AF.request(Endpoint.signin, method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .responseDecodable(of: Token.self)  { response in
                switch response.result {
                case .success(let token):
                    
                    UserDefaults.standard.set(token.refresh, forKey: "refreshToken")
                    UserDefaults.standard.set(token.access, forKey: "accessToken")
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(Date(), forKey: "lastlog")
                    print(token)
                    guard let SigninSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "SigninSuccessViewController") else { return }
                    self.navigationController?.pushViewController(SigninSuccessVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
