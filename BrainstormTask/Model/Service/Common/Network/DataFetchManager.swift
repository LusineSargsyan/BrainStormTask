//
//  File.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift

enum DataFetchManagerProvider {
    static var `default`: DataFetching {
        return DataFetchManager(networking: URLSessionNetworkManager(),
                                parser: JSONDecoderParser())
    }
}

protocol DataFetching {
    var networking: Networking { get }
    var parser: Parsing { get }
    
    func execute<T: Decodable>(with routing: Routing) -> Observable<T>
}

struct DataFetchManager: DataFetching {
    var networking: Networking
    var parser: Parsing
    
    func execute<T>(with routing: Routing) -> Observable<T> where T : Decodable {
        return networking.executeRequest(with: routing)
            .flatMap { data in
                return self.parser.parse(data: data)
            }
    }
}
