//
//  UserListHeaderView.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit

struct UserListHeaderViewModel {
    let dataSource: [String] = ["Users", "Saved users"]
}

final class UserListHeaderView: UIView, Setupable {
    typealias T = UserListHeaderViewModel
    
    @IBOutlet private weak var segmentControlContainer: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var segmentControl: UISegmentedControl?
    private var model:UserListHeaderViewModel? 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearance()
    }
    
    func setup(with model: UserListHeaderViewModel) {
        self.model = model
        for (index, segment) in model.dataSource.enumerated() {
            segmentControl?.insertSegment(withTitle: segment, at: index, animated: false)
        }
        segmentControl!.selectedSegmentIndex = 0
    }
    
    // MARK: - Private API 
    private func setupAppearance() {
        backgroundColor = Color.backgroundColor
        setupSegment()
        setupSearchBar()
    }
    
    private func setupSegment() {
        let segmentControl = UISegmentedControl()
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = Color.selectedGreen
        }
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = Color.selectedGreen
        let font = UIFont.systemFont(ofSize: 11.7)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControlContainer.addSubview(segmentControl)
        segmentControl.addBorderConstraints()
        
        self.segmentControl = segmentControl
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = Color.backgroundColor.cgColor
        searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = Color.backgroundColor
    }
}

// MARK: - UISearchBarDelegate 
extension UserListHeaderView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
    }
}
