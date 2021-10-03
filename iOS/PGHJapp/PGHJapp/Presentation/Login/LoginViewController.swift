//
//  LoginViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/22.
//

import UIKit
import Alamofire // 나중에 지우기
class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction func loginButtonTouched(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
                
      
        APIClient.login(id: username, password: password) { result in
            switch result{
            case .success(let user):
                guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
                  self.navigationController?.pushViewController(homeVC, animated: true)
            case .failure(let error):
                self.simpleAlert(title: "로그인 실패", message: "id, password 오류")
                print(error.localizedDescription)
            }
        }
    }
    
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
        loginButton.layer.cornerRadius = 10
    }

}
