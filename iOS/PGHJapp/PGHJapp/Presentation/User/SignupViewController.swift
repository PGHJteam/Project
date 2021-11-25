//
//  SignupViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/04.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        idTextField.addLeftPadding()
        nameTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        passwordCheckTextField.addLeftPadding()
    }
    
    @IBAction func signupButtonTouched(_ sender: Any) {
        guard let id = idTextField.text, !id.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let email = passwordCheckTextField.text, !email.isEmpty else { return }
        let user = SignupForm(id: id, password: password, name: name)
                
        AF.request(Endpoint.signup , method: .post, parameters: user)
            .response { response in
                switch response.result {
                case .success(_):
                    guard let SignupSuccessViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessViewController") else { return }
                    self.navigationController?.pushViewController(SignupSuccessViewController, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
