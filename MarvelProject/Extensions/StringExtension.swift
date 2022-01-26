//
//  StringExtension.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 24/01/22.
//

import Foundation
import CryptoKit

extension String {
    var md5: String {
        let hash = Insecure.MD5.hash(data: data(using: .utf8)!)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
