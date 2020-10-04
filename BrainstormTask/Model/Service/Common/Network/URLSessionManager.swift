//
//  URLSessionManager.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift

struct URLSessionNetworkManager: Networking {
    func executeRequest(with routing: Routing) -> Observable<Data> {
        return Observable.create { observer in
            guard let request = routing.request else { return Disposables.create() }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    observer.onCompleted()
                } else if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(ServiceError.network)
                    observer.onCompleted()     
                }
            }
            task.resume()
            
            return Disposables.create()
        }
    }    
}
