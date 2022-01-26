//
//  CharactersResponseDTO.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 24/01/22.
//

import Foundation

class CharacterResponseDTO: Decodable {
    var code: Int!
    var data: ResponseData<Character>!
}
