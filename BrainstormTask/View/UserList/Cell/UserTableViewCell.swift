//
//  UserTableViewCell.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxSwift

final class UserTableViewCell: UITableViewCell, Setupable {
    typealias T = UserTableViewCellModel
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearance()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func setup(with model: UserTableViewCellModel) {
        nameLabel.text = model.name
        genderLabel.text = model.gender
        countryLabel.text = model.country
        addressLabel.text = model.address
        userImageView?.image = nil
        model.downloadImage()
            .asDriver(onErrorJustReturn: UIImage(named: "default_avatar"))
            .drive(onNext: { [weak self] image in
                self?.userImageView?.image = image
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private API
    private func setupAppearance() {
        userImageView.layer.cornerRadius = 4
        nameLabel.textColor = .black
        genderLabel.textColor = Color.textGray
        countryLabel.textColor = Color.textGray
        addressLabel.textColor = Color.textGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        genderLabel.font = UIFont.systemFont(ofSize: 15)
        countryLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.font = UIFont.systemFont(ofSize: 15)
    }
}
