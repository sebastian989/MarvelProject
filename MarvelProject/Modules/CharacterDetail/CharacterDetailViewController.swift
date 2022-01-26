//
//  CharacterDetailViewController.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 26/01/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDescriptionLabel: UILabel!
    
    var viewModel: CharacterDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayDetails()
    }
    
    private func displayDetails() {
        characterImageView.showImage(string: viewModel.image)
        characterNameLabel.text = viewModel.characterName
        characterDescriptionLabel.text = viewModel.description
    }

}
