//
//  UserTableViewCellModel.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit
import RxSwift

struct UserTableViewCellModelInputs {
    let downloadManager: Downloading
}

struct UserTableViewCellModel {
    let name: String
    let gender: String
    let country: String
    let address: String
    
    private let model: User
    private let inputs: UserTableViewCellModelInputs
    
    init(model: User, inputs: UserTableViewCellModelInputs) {
        self.name = "\(model.name.first) \(model.name.last)"
        self.gender = "\(model.gender.rawValue) \(model.phone)"
        self.country = "\(model.location.country)"
        self.address = "\(model.location.street.number) \(model.location.street.name)"
        self.inputs = inputs
        self.model = model
    }
    
    func downloadImage() -> Observable<UIImage?> {
        return self.inputs.downloadManager.download(from: model.picture.medium)
            .map { data in
                return UIImage(data: data)
            }
    }

}
