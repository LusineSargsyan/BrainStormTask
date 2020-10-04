//
//  WebService.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift
import RxCocoa

class WebService {
    let dataFetchManager: DataFetching
    init(dataFetchManager: DataFetching) {
        self.dataFetchManager = dataFetchManager
    }
    
    func callService<T: Decodable>(with router: Routing) -> Observable<T> {
        return dataFetchManager.execute(with: router)
    }
}
