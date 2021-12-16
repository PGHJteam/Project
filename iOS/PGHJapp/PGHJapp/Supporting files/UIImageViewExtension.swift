//
//  UIImageViewExtension.swift
//  PGHJapp
//
//  Created by 김지선 on 2021/11/27.
//

import UIKit

extension UIImageView {
    func addShadowToUnder() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
    }
}

extension UIButton {
    func addShadowToUnder() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 2
    }
}
