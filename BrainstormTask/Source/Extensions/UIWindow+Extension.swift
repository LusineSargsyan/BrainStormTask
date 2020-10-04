//
//  UIWindow+Extension.swift
//  BrainstormTask
//
//  Created by lusines on 10/4/20.
//

import UIKit

extension UIWindow {
    var safeAreaBottom: CGFloat {
        var safeAreaSpace: CGFloat = 0.0

        if #available(iOS 11.0, *) {
            safeAreaSpace = UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0.0
        }
        
        return safeAreaSpace
    }
}
