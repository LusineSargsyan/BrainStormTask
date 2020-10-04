//
//  Encoding.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

enum EncoderFactory {
    static func createEncoder(for encoding: ParameterEncodingType) -> Encoding {
        switch encoding {
        case .query:
            return QueryEncoder()
        }
    }
}

protocol Encoding {
    func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
