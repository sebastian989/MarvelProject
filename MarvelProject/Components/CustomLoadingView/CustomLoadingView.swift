//
//  CustomLoadingView.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 26/01/22.
//

import UIKit
import Lottie

class CustomLoadingView {

    static func create() -> UIView {
        let animationView: AnimationView = .init(name: "iron-anim")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }

}
