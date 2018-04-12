//
//  NetworkClient.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum NetworkClientError: Error {
    case invalidUrl
    case invalidResponseObject
    case invalidStatusCode(Int)
    case responseError(Error)
}

typealias NetworkRequestCompletionBlock = (Data?, Error?) -> Void

protocol NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock)
    
}

class SimpleNetworkClient: NSObject, NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod = .get, onCompletion: @escaping NetworkRequestCompletionBlock) {
        
        guard let url = URL(string: url) else {
            onCompletion(nil, NetworkClientError.invalidUrl)
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let task = URLSession(configuration: URLSessionConfiguration.default)
            .dataTask(with: urlRequest) { (data, response, error) in
                
                guard error == nil else {
                    onCompletion(nil, NetworkClientError.responseError(error!))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    onCompletion(nil, NetworkClientError.invalidResponseObject)
                    return
                }
                
                guard response.statusCode == 200 else {
                    onCompletion(nil, NetworkClientError.invalidStatusCode(response.statusCode))
                    return
                }
                
                onCompletion(data, nil)
                
        }
        task.resume()
        
    }
    
}
