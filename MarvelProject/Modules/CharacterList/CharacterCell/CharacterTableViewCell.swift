//
//  CharacterTableViewCell.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 24/01/22.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    static let identifier = "CharacterTableViewCell"

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.addCornerRadius()
        containerView.addShadow()
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      
      configure(with: .none)
    }
    
    func configure(with viewModel: CharacterViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        thumbnailImageView.showImage(string: viewModel.thumbnail)
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
    }
}
