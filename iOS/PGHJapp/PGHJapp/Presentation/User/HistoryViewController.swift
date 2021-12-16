//
//  HistoryViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/27.
//

import UIKit

class HistoryViewController: UIViewController {
    var history: History? = nil
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: HistoryCell.id, bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: HistoryCell.id)
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history?.totalCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.id, for: indexPath) as? HistoryCell else{return UITableViewCell()}
        let materialName = history?.totalMaterials()[indexPath.row] ?? "sample.pptx"
        cell.configure(name: materialName)
        return cell
    }
}
