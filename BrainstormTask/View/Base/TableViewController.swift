//
//  BaseTableViewController.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxSwift
import RxRelay

class TableViewController<VM: TableViewViewModeling, Cell: UITableViewCell>: ViewController<VM>, UITableViewDelegate, UITableViewDataSource where Cell: Setupable, VM.CellModel == Cell.Model {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.addBorderConstraints()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }

    override func bindViewModel() {
        super.bindViewModel()

        bindDataSource()
    }

    func handle(dataSource: [VM.CellModel]) {
        tableView.reloadData()
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) 
        (cell as? Cell)?.setup(with: viewModel.dataSource.value[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {}

    // MARK: - Private API 
    private func bindDataSource() {
        viewModel.dataSource
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] dataSource in
                self?.handle(dataSource: dataSource)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellReuseIdentifier: String(describing: Cell.self))
    }
    
}

