//
//  CharacterViewModel.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 24/01/22.
//

import Foundation

class CharacterViewModel {
    
    var thumbnail: String {
        character.thumbnail.source
    }
    
    var name: String {
        character.name
    }
    
    var description: String {
        character.description
    }
    
    private let character: Character
    
    init(character: Character) {
        self.character = character
    }
}
