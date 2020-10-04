//
//  ServiceError.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation

public enum ServiceError: Error {
    case network
    case parsing
    case noURL
}
