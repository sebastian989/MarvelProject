//
//  UIViewExtension.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 25/01/22.
//

import Foundation
import UIKit

extension UIView {
    
    func addCornerRadius(radius: CGFloat = 8) {
        layer.cornerRadius = radius
    }
    
    func addShadow(
        shadowColor: CGColor = UIColor.lightGray.cgColor,
        shadowOffset: CGSize = CGSize(width: 2, height: 2),
        shadowOpacity: Float = 0.5,
        shadowRadius: CGFloat = 3) {
            layer.shadowColor = shadowColor
            layer.shadowOffset = shadowOffset
            layer.shadowOpacity = shadowOpacity
            layer.shadowRadius = shadowRadius
    }
}
