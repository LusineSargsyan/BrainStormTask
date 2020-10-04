//
//  ViewControllerProvider.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

enum ViewControllerProvider {
    static var userList: UserListViewController { 
        let userListViewController = UserListViewController()
        let inputs = UserListInputs(service: UserWebService(dataFetchManager: DataFetchManagerProvider.default), downloadManager: DownloadManager())
        userListViewController.viewModel = UserListViewModel(inputs: inputs)
        
        return userListViewController
    }
}
