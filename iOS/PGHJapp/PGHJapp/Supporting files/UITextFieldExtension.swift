//
//  UITextFieldExtension.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/25.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
