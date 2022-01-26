//
//  ApiInterface.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation

/// Response Api Handler
public typealias ApiHandler<T> = ( (_ result: Result<T, ApiError>) -> Void )

// Parser for the Endpoint before to response with builded data.
public typealias PreApiHandler<T> = ( (_ data: Data, _ code: Int, _ handler: ApiHandler<T>?) -> Void )

/// Renaming dictionary to HTTPHeaders
public typealias HTTPHeaders = [String: String]

public struct EndPoint<T> {
    public var baseURL: URL
    public var path: String
    public var httpMethod: HTTPMethod = .get
    public var headers: HTTPHeaders?
    public var parameters: [String: Any?]?
    public var repeatParameters: [String: [String]]?
    public var parser: PreApiHandler<T>?
    public var cache: NSURLRequest.CachePolicy?

    public init(
        baseURL: URL,
        path: String,
        httpMethod: HTTPMethod = .get,
        headers: HTTPHeaders? = [:],
        parameters: [String: Any]? = [:],
        repeatParameters: [String: [String]]? = [:],
        parser: PreApiHandler<T>?,
        cache: NSURLRequest.CachePolicy? = .reloadIgnoringLocalCacheData) {

        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.headers = headers
        self.parameters = parameters
        self.repeatParameters = repeatParameters
        self.parser = parser
        self.cache = cache
    }
}

//public enum ApiResponse {
//    case success(data: Any)
//    case failure(error: Error)
//}

/// Basic HTTP Methods
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Protocol Api Definition
public protocol ApiProtocol {
    @discardableResult
    func request<T>(_ request: EndPoint<T>, handler: ApiHandler<T>?) -> String?
    func cancelRequests(ids requestIds: String...)
}
