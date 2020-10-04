//
//  ViewModel.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxSwift
import RxRelay

enum ViewError: Error {
    case service
    case technical
    case unexpected
    
    var message: String {
        switch self {
        case .service:
            return "Something wrong with request!"
        case .technical:
            return "Sorry, we have some technical issue!"
        case .unexpected:
            return "Sorry, we have some unexpected issue!"
        }
    }    
}

protocol ViewModeling {
    var disposeBag: DisposeBag { get set }
    var errorRelay: BehaviorRelay<ViewError?> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var isEmpty: BehaviorRelay<Bool> { get set }

    func handleError(error: Error)
    func retry()
}

class ViewModel<Inputs>: ViewModeling {
    var isEmpty: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var errorRelay: BehaviorRelay<ViewError?> = BehaviorRelay<ViewError?>(value: nil)
    var disposeBag: DisposeBag = DisposeBag()
    
    let inputs: Inputs
    
    init(inputs: Inputs) {
        self.inputs = inputs
    }
    
    func handleError(error: Error) {
        switch error {
        case ServiceError.network:
            errorRelay.accept(ViewError.service)
        case ServiceError.noURL, ServiceError.parsing:
            errorRelay.accept(ViewError.technical)
        default:
            errorRelay.accept(ViewError.unexpected)
        }
    }
    
    func retry() {}
    
}
