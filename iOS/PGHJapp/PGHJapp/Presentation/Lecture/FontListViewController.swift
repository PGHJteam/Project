//
//  FontListViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/05.
//

import UIKit

class FontListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()

    }
    private func registerXib() {
        let nibName = UINib(nibName: FontCell.id, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: FontCell.id)
    }

    @IBAction func selectButtonTouched(_ sender: Any) {
    }
}

extension FontListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Fonts.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FontCell.id, for: indexPath) as? FontCell else{return UITableViewCell()}
        let fontName = Fonts.list[indexPath.row]
        cell.configure(fontName: fontName)
        return cell
    }
}

extension FontListViewController: UITableViewDelegate {
    
}
