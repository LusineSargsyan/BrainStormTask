//
//  Networking.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift

protocol Networking {
    func executeRequest(with routing: Routing) -> Observable<Data>
}
