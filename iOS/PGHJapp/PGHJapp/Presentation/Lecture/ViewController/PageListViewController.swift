//
//  PageListViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/12/08.
//

import UIKit

class PageListViewController: UIViewController {
//    var lecture: Lecture?

    var lecture = Lecture(uploadID: 1, name: "sample.pptx", templateID: "template01-01",
                          pages: [Page(id: 0, sentences: [Sentence(sentence: "important", coordinate: Coordinate(left: 0.34, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic")), Sentence(sentence: "task", coordinate: Coordinate(left: 0.5, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic"))]),
                                  Page(id: 1, sentences: [Sentence(sentence: "second", coordinate: Coordinate(left: 0.34, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic"))]),
                                  Page(id: 2, sentences: [Sentence(sentence: "three", coordinate: Coordinate(left: 0.34, top: 0.21), size: Size(height: 0.56, width: 0.45), font: Font(size: 10, type: "NanumBarunGothic"))])])
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTouched(_ sender: Any) {
        guard let downloadVC = self.storyboard?.instantiateViewController(withIdentifier: "DownloadViewController") as? DownloadViewController else { return }
        downloadVC.lecture = lecture
        self.navigationController?.pushViewController(downloadVC, animated: true)
    }
}

extension PageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lecture.pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PageCell.id, for: indexPath) as? PageCell else{return UITableViewCell()}
        let pageID = lecture.pages[indexPath.row].id
        cell.configure(id: pageID)
        return cell
    }
}

extension PageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let pageID = indexPath.row
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else { return }
        editVC.pageID = pageID
        editVC.lecture = lecture
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension PageListViewController: EditDelegate {
    func sendEditedLecture(lecture: Lecture?) {
        guard let lecture = lecture else {return}
        self.lecture = lecture
    }
}
