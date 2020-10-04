//
//  UserListViewModel.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxRelay
import RxCocoa

struct UserListInputs {
    let service: UserWebService
    let downloadManager: Downloading
}

final class UserListViewModel: ViewModel<UserListInputs>, TableViewViewModeling {
    typealias CellModel = UserTableViewCellModel
    
    private var fullDataSource: [UserTableViewCellModel] = [] {
        didSet {
            dataSource.accept(query.isEmpty ? fullDataSource : fullDataSource.filter { $0.name.lowercased().contains(query.lowercased())})
        }
    }
    
    private var query: String = ""
    let result = 20
    var page = 1
    var dataSource: BehaviorRelay<[UserTableViewCellModel]> = BehaviorRelay<[UserTableViewCellModel]>(value: [])
    
    override init(inputs: UserListInputs) {
        super.init(inputs: inputs)
        
        dataSource
            .asDriver()
            .drive(onNext: { [weak self] dataSource in
                self?.isEmpty.accept(dataSource.isEmpty)
            })
            .disposed(by: disposeBag)
    }

    func getUserList(shouldLoadNextPage: Bool = false) {
        if shouldLoadNextPage {
            page += 1
        }

        isLoading.accept(true)
        inputs.service.getUserList(routing: UserListRouter(result: result, page: page))
            .asObservable()
            .subscribe(onNext: { [weak self] userResponse in
                guard let strongSelf = self else { return }

                strongSelf.isLoading.accept(false)
                strongSelf.fullDataSource += userResponse.results.map { UserTableViewCellModel(model: $0, inputs: UserTableViewCellModelInputs(downloadManager: strongSelf.inputs.downloadManager)) }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.handleError(error: error)
            })
            .disposed(by: disposeBag)
    }
    
    override func retry() {
        getUserList()
    }
    
    func filter(with query: String) {
        self.query = query
        dataSource.accept(query.isEmpty ? fullDataSource : fullDataSource.filter { $0.name.lowercased().contains(query.lowercased())})
    }
    
    func update(with index: Int) {
        dataSource.accept((index == 0) ? query.isEmpty ? fullDataSource : fullDataSource.filter { $0.name.lowercased().contains(query.lowercased())} : [])
    }
}
