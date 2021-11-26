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

        // label: 몇일 만에 방문했는지, 이전기록 없다면 처음만나서 반갑다는 멘트!
        // 이전 접속 날짜가 없다면 - 처음 방문 환영
        // 이전 접속 날짜가 오늘이라면 - 다시만나서 반갑다는 인사
    }
    @IBAction func homeButtonTouched(_ sender: Any) {
        guard let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") else { return }
        self.navigationController?.pushViewController(TabBarController, animated: true)
    }
}
