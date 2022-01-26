//
//  UIImageView.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 25/01/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func showImage(string: String) {
        let url = URL(string: string)
        kf.indicatorType = .activity
        self.kf.setImage(with: url)
    }
}
