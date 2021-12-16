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
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        idTextField.addLeftPadding()
        nameTextField.addLeftPadding()
        passwordTextField.addLeftPadding()
        emailTextField.addLeftPadding()
//        idTextField.delegate = self
//        nameTextField.delegate = self
//        passwordTextField.delegate = self
//        emailTextField.delegate = self
    }
    
    @IBAction func signupButtonTouched(_ sender: Any) {
        guard let id = idTextField.text, !id.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let email = emailTextField.text, !email.isEmpty else { return }
        print(id, password, name, email)
        let user = SignupForm(id: id, password: password, name: name, email: email)
        print(user)
                
        AF.request(Endpoint.signup , method: .post, parameters: user, encoder: JSONParameterEncoder.default)
            .response { response in
                print(response)
                switch response.result {
                case .success(_):
                    guard let SignupSuccessVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessViewController") else { return }
                    self.navigationController?.pushViewController(SignupSuccessVC, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//extension SignupViewController: UITextViewDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
