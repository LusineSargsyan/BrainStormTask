//
//  Parsing.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift

protocol Parsing {
    func parse<T: Decodable>(data: Data) -> Observable<T>
}

struct JSONDecoderParser: Parsing {
    func parse<T>(data: Data) -> Observable<T> where T : Decodable {
        return Observable.create { observer in
            do {
                let parsedObject = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(parsedObject)
                observer.onCompleted()
            } catch {
                print((error as? DecodingError) ?? error)
                observer.onError(ServiceError.parsing)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
