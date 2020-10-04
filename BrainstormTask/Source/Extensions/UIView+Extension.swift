//
//  UIView+Extension.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import UIKit

extension UIView {
    func addBorderConstraints(with edge: UIEdgeInsets = .zero) {
        guard let superView = self.superview else {
            preconditionFailure("Before adding constraint \(self) should has superview!")
        }
        
        let constraints = [self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: edge.left),
                           superView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: edge.right),
                           self.topAnchor.constraint(equalTo: superView.topAnchor, constant: edge.top),
                           superView.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: edge.bottom)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    static func loadNib() -> Self? {
        let bundle = Bundle(for: self)
        
        return bundle.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? Self
    }
}
