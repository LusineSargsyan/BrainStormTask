//
//  Routing.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

let baseURL = "https://randomuser.me/api?seed=f56c3536f1e402ec"

enum ParameterEncodingType {
    case query
}

enum HeadersFactory {
    static var empty: HTTPHeader { [:] }
    
    static func createHeader(for encoding: ParameterEncodingType) -> HTTPHeader {
        switch encoding {
        case .query:
            return empty
        }
    }
}

protocol Routing {
    var path: String { get }
    var headers: HTTPHeader { get }
    var parameters: Parameters { get }
    var httpMethod: HTTPMethod { get }
    var encoding: ParameterEncodingType { get }
    var request: URLRequest? { get }
}

extension Routing {
    var request: URLRequest? {
        guard let url = URL(string: "\(baseURL)\(path)") else { return nil}
        
        var urlRequest = URLRequest(url: url)
        let encoder =  EncoderFactory.createEncoder(for: encoding)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        do {
            try? encoder.encode(urlRequest: &urlRequest, with: parameters)
        }
        
        headers.forEach { 
            urlRequest.addValue($1, forHTTPHeaderField: $0)
        }
        
        return urlRequest
    }
    
    var headers: HTTPHeader {
        return HeadersFactory.createHeader(for: encoding)
    }
}
