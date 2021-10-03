//
//  TextViewController.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/09/27.
//

import UIKit

class TextViewController: UIViewController {
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBOutlet weak var textView: UITextView!
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
       
    }
    
    @objc func keyboardWillAppear(_ sender: NotificationCenter){
        self.view.frame.origin.y -= 150
    }
    
    @objc func keyboardWillDisappear(_ sender: NotificationCenter){
        self.view.frame.origin.y += 150
    }

}
