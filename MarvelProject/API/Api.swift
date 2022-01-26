//
//  Api.swift
//  MarvelProject
//
//  Created by Sebastian Gomez Osorio on 23/01/22.
//

import Foundation

public class RequestBuild<T> {

    /// In charge to create the URL based in the current endpoint data, and if it will
    /// send the data using right http method.
    ///
    /// - Parameter request: Protocol where we conform the endpoint necesary data.
    /// - Returns: the created URL
    private static func uri(request: EndPoint<T>) -> URL? {
        guard let url = URL(string: request.path, relativeTo: request.baseURL) else {
            return request.baseURL
        }

        if request.httpMethod == .post {
            return url
        }

        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            return url
        }

        guard let parameters = request.parameters else {
            return url
        }

        urlComponents.queryItems = []
        for (key, value) in parameters {
            guard let value = value else { continue }
            let item = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(item)
        }

        guard let repeatParameters = request.repeatParameters else {
            return urlComponents.url
        }

        for (key, values) in repeatParameters {
            let queryItems = values.map {
                URLQueryItem(name: key, value: "\($0)")
            }

            urlComponents.queryItems?.append(contentsOf: queryItems)
        }

        return urlComponents.url
    }

    /// This function convert the EndPoint model in a URLRequest, based in the data value
    /// using cache, headers and body.
    ///
    /// - Parameter request: EndPoint request
    /// - Returns: the builded URLRequest acording with the current EndPoint
    public static func build(request: EndPoint<T>) -> URLRequest? {
        guard let uri = uri(request: request) else {
            return nil
        }

        var urlRequest = URLRequest(url: uri)
        urlRequest.httpMethod = request.httpMethod.rawValue

        if let cache = request.cache {
            urlRequest.cachePolicy = cache
        }

        urlRequest.allHTTPHeaderFields = request.headers

        if request.httpMethod == .post {
            urlRequest.httpBody = jsonData(request: request)
        }

        return urlRequest
    }

    /// Convert the EndPoint parameters in Data
    ///
    /// - Parameter request: EndPoint request
    /// - Returns: data coverted from parameters
    private static func jsonData(request: EndPoint<T>) -> Data? {
        guard let parameters = request.parameters else {
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters)
            return data
        } catch {
            print("Failed to load: \(error.localizedDescription)")
        }

        return nil
    }
}

/// Api is a basic HTTP Implementation using the ApiProtocol, it's basic and convenience if you
/// will use basic requests.
public class Api: ApiProtocol {

    private var requests = [String: URLSessionDataTask]()

    public init() {}

    /// Send Api Request
    ///
    /// - Parameters:
    ///   - request: EndPoint Request
    ///   - handler: Result Handler
    public func request<T>(_ request: EndPoint<T>, handler: ApiHandler<T>?) -> String? {

        let taskId = UUID().uuidString

        /// We created the Url request for our session task.
        guard let urlRequest = RequestBuild.build(request: request) else {
            let error = ApiError.buildRequest
            handler?(.failure(error))
            return nil
        }

        print(urlRequest)
        DispatchQueue.global(qos: .background).async { [weak self] in
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in

                self?.requests[taskId] = nil

                /// If we detect some api error
                if let _ = error {
                    DispatchQueue.main.async {
                        handler?(.failure(.notAResponse))
                    }
                    return
                }

                /// We guard the response
                guard let response = response as? HTTPURLResponse else {
                    let error = ApiError.notAResponse
                    DispatchQueue.main.async {
                        handler?(.failure(error))
                    }
                    return
                }

                /// We guard the data exist
                guard let data = data else {
                    let error = ApiError.emptyData
                    DispatchQueue.main.async {
                        handler?(.failure(error))
                    }
                    return
                }

                /// Validating status code
                let code = response.statusCode
                if !(code >= 200 && code < 300) {
                    DispatchQueue.main.async {
                        let error = ApiError.badStatusCode
                        handler?(.failure(error))
                    }
                    return
                }

                DispatchQueue.main.async {
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json ?? "")
                    request.parser?(data, code, handler)
                }
            }

            self?.requests[taskId] = task
            task.resume()
        }

        return taskId
    }

    /// Cancel Api Request
    ///
    /// - Parameters:
    ///   - ids: Request's ids to cancel
    public func cancelRequests(ids requestIds: String...) {
        requestIds.forEach {
            requests[$0]?.cancel()
        }
    }
}
