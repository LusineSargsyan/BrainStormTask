//
//  Setupable.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

protocol Setupable {
    associatedtype Model

    func setup(with model: Model)
}
