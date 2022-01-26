//
//  Character.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation

class Character: Decodable {
    var id: Int!
    var name: String!
    var description: String!
    var thumbnail: Thumbnail!
}

class Thumbnail: Decodable {
    var path: String!
    var `extension`: String!
    
    var source: String {
        return String(format: "%@.%@", path, `extension`)
    }
}
