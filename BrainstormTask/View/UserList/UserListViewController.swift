//
//  UserListViewController.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxSwift

final class UserListViewController: TableViewController<UserListViewModel, UserTableViewCell> {  
    override var emptyViewEdges: UIEdgeInsets { return .init(top: 170, left: 0, bottom: 0, right: 0) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.backgroundColor = Color.backgroundColor
        setupTableViewHeader()
        viewModel.getUserList()
    }

    // MARK: - Private API
    private func setupTableViewHeader() {
        guard let headerView = UserListHeaderView.loadNib() else { return } 
    
        headerView.setup(with: UserListHeaderViewModel())
        headerView.translatesAutoresizingMaskIntoConstraints = false
        bindSearchBar(searchBar: headerView.searchBar)
        if let segmentControl = headerView.segmentControl {
            bindSegmentControl(segmentControl: segmentControl)
        }
        headerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        tableView.tableHeaderView = headerView
    }
    
    private func bindSearchBar(searchBar: UISearchBar) {
        searchBar
            .rx.text 
            .orEmpty 
            .skip(1)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) 
            .distinctUntilChanged() 
            .subscribe(onNext: { [weak self] query in 
                self?.viewModel.filter(with: query)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSegmentControl(segmentControl: UISegmentedControl) {
        segmentControl
            .rx
            .selectedSegmentIndex
            .asDriver()
            .drive(onNext: { [weak self] index in
                self?.viewModel.update(with: index)
            })
            .disposed(by: disposeBag)
    }
    
   private func goToUserViewController(at index: Int) {
        let userDetailViewController = UserDetailViewController()
    userDetailViewController.modalPresentationStyle = .fullScreen
        present(userDetailViewController, animated: false, completion: nil)
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        
        goToUserViewController(at: indexPath.row)
    }
    
    //MARK: - UIScrollViewDelegate
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == tableView else { return }
        
        if !decelerate {
            let safeAreaSpace = UIApplication.keyWindow?.safeAreaBottom ?? 0.0
            let yOffset = tableView.contentSize.height - tableView.frame.size.height + safeAreaSpace
            
            if Int(scrollView.contentOffset.y) == Int(yOffset) {
                viewModel.getUserList(shouldLoadNextPage: true)
            }
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.tableView else { return }
        
        let safeAreaSpace = UIApplication.keyWindow?.safeAreaBottom ?? 0.0
        let yOffset = tableView.contentSize.height - tableView.frame.size.height + safeAreaSpace
        
        if Int(scrollView.contentOffset.y) == Int(yOffset) {
            viewModel.getUserList(shouldLoadNextPage: true)
        }
    }
}

