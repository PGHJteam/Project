//
//  LoginViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/22.
//

import UIKit
import Alamofire // 나중에 지우기
class SigninViewController: UIViewController {

    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        let user = SigninForm(id: username, password: password)
                
        AF.request(Endpoint.signin, method: .post, parameters: user)
            .responseDecodable(of: Token.self)  { response in
                
//                print(Endpoint.signin)
                switch response.result {
                case .success(let token):
//                    print(token)
                    UserDefaults.standard.set(token.refresh, forKey: "refreshToken")
                    UserDefaults.standard.set(token.access, forKey: "accessToken")
                    guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
                    self.navigationController?.pushViewController(homeVC, animated: true)

                    
                case .failure(let error):
                    print(error)
                }
            }
    }
      
//        if APIClient.login(id: username, password: password) {
//            guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
//            self.navigationController?.pushViewController(homeVC, animated: true)
//        } else {
//            simpleAlert(title: "로그인 실패", message: "id, password 오류")
//        }
//        { result in
//            switch result{
//            case .success(let user):
//                guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
//                  self.navigationController?.pushViewController(homeVC, animated: true)
//            case .failure(let error):
//                self.simpleAlert(title: "로그인 실패", message: "id, password 오류")
//                print(error.localizedDescription)
//            }
//        }
    
    
    // 알림 창 띄우는 함수
    func simpleAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인"
                                     
                                     ,style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    
    private func configure() {
        signinButton.layer.cornerRadius = 10
    }

}
