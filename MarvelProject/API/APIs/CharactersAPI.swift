//
//  CharactersAPI.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation

extension EndPoint {
    
    static func getCharacters(
        limit: Int,
        offset: Int,
        hash: String,
        apiKey: String,
        ts: String) -> EndPoint {
        return EndPoint(
            baseURL: URL(string: Constants.API.baseURL)!,
            path: Constants.API.charactersPath,
            parameters: [
                "apikey": apiKey,
                "limit": limit,
                "offset": offset,
                "ts": ts,
                "hash": hash
            ],
            parser: { (data, _, handler) in
                do {
                    let decoder = JSONDecoder()
                    guard let charactersResponse = try decoder.decode(CharacterResponseDTO.self, from: data) as? T else {
                        handler?(.failure(.decodeData))
                        return
                    }
                    print(data)
                    handler?(.success(charactersResponse))
                } catch {
                    handler?(.failure(.decodeData))
                }
            
            })
    }
}
