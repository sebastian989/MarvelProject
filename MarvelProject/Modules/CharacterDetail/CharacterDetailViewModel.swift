//
//  CharacterDetailViewModel.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 26/01/22.
//

import Foundation

class CharacterDetailViewModel {
    
    var characterName: String {
        return character.name
    }
    
    var description: String {
        return character.description
    }
    
    var image: String {
        return character.thumbnail.source
    }
    
    private let character: Character!
    
    init(character: Character) {
        self.character = character
    }
}
