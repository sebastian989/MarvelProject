//
//  ApiError.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 24/01/22.
//

import Foundation

public enum ApiError: Error {
    case buildRequest
    case notAResponse
    case emptyData
    case badStatusCode
    case decodeData
    
    var reason: String {
      switch self {
      case .buildRequest, .notAResponse, .badStatusCode:
        return "An error occurred while fetching data"
      case .emptyData, .decodeData:
        return "An error occurred while decoding data"
      }
    }
}
