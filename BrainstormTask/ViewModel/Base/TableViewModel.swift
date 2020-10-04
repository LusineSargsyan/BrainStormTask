//
//  TableViewModel.swift
//  BrainstormTask
//
//  Created by lusines on 10/3/20.
//

import Foundation
import RxRelay

protocol TableViewViewModeling: ViewModeling { 
    associatedtype CellModel
    
    var dataSource: BehaviorRelay<[CellModel]> { get }
}
