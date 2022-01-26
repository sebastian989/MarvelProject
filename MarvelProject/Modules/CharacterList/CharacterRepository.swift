//
//  CharacterRepository.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation

protocol CharacterRepository {
    init(api: ApiProtocol)
    
    func getCharacters(
        limit: Int,
        offset: Int,
        response: (@escaping (Result<CharacterResponseDTO, ApiError>) -> Void))
}

struct CharacterRepositoryImpl: CharacterRepository {
    
    private let api: ApiProtocol
    
    init(api: ApiProtocol = Api()) {
        self.api = api
    }
    
    func getCharacters(
        limit: Int = 20,
        offset: Int,
        response: (@escaping (Result<CharacterResponseDTO, ApiError>) -> Void)) {
        
        let ts = String(Date().timeIntervalSince1970)
        guard let dictionary = Bundle.main.infoDictionary,
              let publicKey = dictionary["PUBLIC_API_KEY"] as? String,
              let privateKey = dictionary["PRIVATE_API_KEY"] as? String else { return }
        
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        let request = EndPoint<CharacterResponseDTO>
            .getCharacters(limit: limit, offset: offset, hash: hash, apiKey: publicKey, ts: ts)
        api.request(request) { (result) in
            response(result)
        }
    }
}

extension Date{
    func stringValue() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSSSS'Z'"
            return dateFormatter.string(from: self)
        }
}
