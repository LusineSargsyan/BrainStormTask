//
//  ViewController.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxSwift
import RxRelay

class ViewController<VM: ViewModeling>: UIViewController {
    // Explicit unwrapped optional to avoid logical issues
    var viewModel: VM! 
    let disposeBag = DisposeBag()
    var loadingView: UIView?
    var emptyView: UIView?
    var emptyViewEdges: UIEdgeInsets { return .zero }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    func bindViewModel() {
        bindLoading()
        bindError()
        bindEmptyView()
    }

    func handle(error: ViewError) {
        let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.retry()
        } 
        
        let alertView = AlertManager.create(with: AlertModel(title: nil, message: error.message, actions: [action]))
        present(alertView, animated: true, completion: nil)
    }
    
    func handle(isLoading: Bool) {
        if isLoading {
            guard self.loadingView == nil else { return }
            
            let loadingView = UIView(frame: UIScreen.main.bounds)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            view.addSubview(loadingView)
            loadingView.addBorderConstraints()
            
            let circleView = UIView()
            circleView.backgroundColor = Color.selectedGreen
            circleView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addSubview(circleView)

            NSLayoutConstraint.activate([
                circleView.widthAnchor.constraint(equalToConstant: 60),
                circleView.heightAnchor.constraint(equalToConstant: 60),
                circleView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: 0),
                circleView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor, constant: 0)
            ])

            circleView.layer.cornerRadius = 30

            let indicatorView = UIActivityIndicatorView(style: .large)
            indicatorView.color = .white
            indicatorView.startAnimating()
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.addSubview(indicatorView)
            
            NSLayoutConstraint.activate([
                indicatorView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor, constant: 0),
                indicatorView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor, constant: 0)
            ])

            self.loadingView = loadingView
        } else {
            loadingView?.removeFromSuperview()
            loadingView = nil
        }
    }
    
    func handleEmptyView(isEmpty: Bool) {
        if isEmpty {
            guard self.loadingView == nil else { return }
            
            let emptyView = UIView(frame: UIScreen.main.bounds)
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            emptyView.backgroundColor = .clear
            view.addSubview(emptyView)
            emptyView.addBorderConstraints(with: emptyViewEdges)
            
            let titleLabel = UILabel()
            titleLabel.text = "Empty"
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyView.addSubview(titleLabel)
            titleLabel.addBorderConstraints()
            
            self.emptyView = emptyView
        } else {
            emptyView?.removeFromSuperview()
            emptyView = nil
        }
    }
    
    // MARK: - Private API
    private func bindEmptyView() {
        viewModel.isEmpty
            .asDriver()
            .drive(onNext: { [weak self] isEmpty in
                self?.handleEmptyView(isEmpty: isEmpty)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.errorRelay
            .asDriver()
            .filter { $0 != nil }
            .drive(onNext: { [weak self] viewError in
                self?.handle(error: viewError!)
            })
            .disposed(by: disposeBag) 
    }
    
    private func bindLoading() {
        viewModel.isLoading
            .asDriver()
            .drive(onNext: { [weak self] isLoading in
                self?.handle(isLoading: isLoading)
            })
            .disposed(by: disposeBag)
    }
}
