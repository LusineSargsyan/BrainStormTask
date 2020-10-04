//
//  QueryEncoder.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

struct QueryEncoder: Encoding {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw ServiceError.noURL }
        
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            components.queryItems = parameters.map ({
                if let value = $1 as? String {
                    return URLQueryItem(name: $0, value: value) 
                } else {
                    return URLQueryItem(name: $0, value: "\($1)") 
                }
            })
            
            urlRequest.url = components.url
        }
    }
}
