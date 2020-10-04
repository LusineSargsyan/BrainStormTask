//
//  DownloadManager.swift
//  BrainstormTask
//
//  Created by lusines on 10/4/20.
//

import Foundation
import RxSwift

protocol Downloading {
     func download(from urlString: String) -> Observable<Data>
}

final class DownloadManager: Downloading {
    enum State {
        case loading
        case error(error: Error)
        case success(data: Data)
        
        var isError: Bool {
            switch self {
            case .error:
                return true
            default:
                return false
            }
        }
    }

    var cache: [String: State] = [:]

    var postDownloadActions: [String: [(Data) -> Void]] = [:]
    func download(from urlString: String) -> Observable<Data> {
        return Observable.create { [weak self] observer in
            guard let strongSelf = self else { return Disposables.create() }

            let state = strongSelf.cache[urlString] 
           
            if let state = state, !state.isError {
                switch state {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .loading:  
                    var actions = strongSelf.postDownloadActions[urlString, default: []]
                    
                    actions.append({ data in
                        observer.onNext(data)
                        observer.onCompleted()
                    })

                    strongSelf.postDownloadActions[urlString] = actions
                case .error: break
                }
            } else {
                guard let url = URL(string: urlString) else { return Disposables.create() }
                
                strongSelf.cache[urlString] = .loading

                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        strongSelf.cache[urlString] = .error(error: error)
                        observer.onError(error)
                        observer.onCompleted()
                    } else if let data = data {
                        strongSelf.cache[urlString] = .success(data: data)
                        observer.onNext(data)
                        observer.onCompleted()
                        
                        strongSelf.postDownloadActions[urlString]?.forEach { action in
                            action(data)
                        }
                        
                        strongSelf.postDownloadActions[urlString] = []
                    } else {
                        observer.onError(ServiceError.network)
                        observer.onCompleted()     
                    }
                }
                task.resume()
            }

            return Disposables.create()
        }
    }
}
