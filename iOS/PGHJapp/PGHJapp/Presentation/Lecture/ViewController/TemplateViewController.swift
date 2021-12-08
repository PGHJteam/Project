//
//  TemplateViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/10/11.
//

import UIKit

protocol TemplateDelegate {
    func sendTemplateStyle(id: String?)
}

class TemplateViewController: UIViewController {
    private var templateID: String = Templates.getID(number: 0)
    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: TemplateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.sendTemplateStyle(id: templateID)
    }
    
    @IBAction func selectButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TemplateViewController: UICollectionViewDataSource {
    private func configureLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 5
        let width = collectionView.frame.width

        let cellWidth = (width / 3) * 1.3
        let cellHeight = cellWidth * (9/16)
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Templates.totalNumber
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemplateCell.id, for: indexPath) as? TemplateCell else { return UICollectionViewCell() }
        let templateID = Templates.getID(number: indexPath.row)
        cell.configure(templateID: templateID)
        
        if indexPath.item == 0 {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
}

extension TemplateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        templateID = Templates.getID(number: indexPath.row)
    }
}
