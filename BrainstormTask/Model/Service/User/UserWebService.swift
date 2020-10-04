//
//  UserService.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift
import RxCocoa

class UserWebService: WebService {    
    func getUserList(routing: UserListRouter) -> Observable<UserResponse> {
        return callService(with: routing)
    }
}
