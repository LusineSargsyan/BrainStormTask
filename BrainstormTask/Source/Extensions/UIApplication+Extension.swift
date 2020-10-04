//
//  UIApplication+Extension.swift
//  BrainstormTask
//
//  Created by lusines on 10/4/20.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}

