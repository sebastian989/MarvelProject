//
//  Data.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 25/01/22.
//

import Foundation

struct ResponseData<T: Decodable>: Decodable {
    var total: Int!
    var results: [T]!
}
