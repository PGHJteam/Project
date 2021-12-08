//
//  SigninSuccessViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/25.
//

import UIKit

class SigninSuccessViewController: UIViewController {

    @IBOutlet weak var welcomeTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // label: 몇일 만에 방문했는지, 이전기록 없다면 처음만나서 반갑다는 멘트!
        // 이전 접속 날짜가 없다면 - 처음 방문 환영
        // 이전 접속 날짜가 오늘이라면 - 다시만나서 반갑다는 인사
    }
    
    private func configure() {
        let username = UserDefaults.standard.string(forKey: "username")!
        welcomeTextLabel.text = "\(username)님 반갑습니다"
    }
    @IBAction func homeButtonTouched(_ sender: Any) {
        guard let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") else { return }
        self.navigationController?.pushViewController(TabBarController, animated: true)
    }
}
