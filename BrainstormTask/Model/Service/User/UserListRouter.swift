//
//  UserListRouter.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

struct UserListRouter: Routing {
    let result: Int
    let page: Int
    
    var path: String { return "" }
    
    var parameters: Parameters { 
        return ["results": result,
                "page": page]
    }
    
    var httpMethod: HTTPMethod { return .get}
    
    var encoding: ParameterEncodingType { return .query }
    
    var headers: HTTPHeader {
        let header = HeadersFactory.empty
        
        return header
    }
}
