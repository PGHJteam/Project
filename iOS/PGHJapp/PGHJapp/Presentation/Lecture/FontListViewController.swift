//
//  FontListViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/05.
//

import UIKit

protocol FontDelegate {
    func sendFontStyle(name: String?)
}

class FontListViewController: UIViewController {
    private var selectedFontStyle: String?
    var delegate: FontDelegate?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    private func registerXib() {
        let nibName = UINib(nibName: FontCell.id, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: FontCell.id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.sendFontStyle(name: selectedFontStyle)
    }

    @IBAction func selectButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFontStyle = Fonts.list[indexPath.row]
    }
}
