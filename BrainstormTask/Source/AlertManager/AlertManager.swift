//
//  AlertManager.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit

struct AlertModel {
    let title: String?
    let message: String?
    let preferredStyle: UIAlertController.Style
    let actions: [UIAlertAction]
    
    init(title: String?, message: String?, actions: [UIAlertAction], preferredStyle: UIAlertController.Style = .alert) {
        self.title = title
        self.message = message
        self.actions = actions
        self.preferredStyle = preferredStyle
    }
}

struct AlertManager {
    private init() {}
    
    static func create(with model: AlertModel) -> UIAlertController {
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: model.preferredStyle)
        let actions = model.actions.isEmpty ? [UIAlertAction(title: "OK", style: .default)] : model.actions
        
        for action in actions {
            alertController.addAction(action)
        }
        
        return alertController
    }
}
