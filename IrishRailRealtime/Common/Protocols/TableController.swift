//
//  TableController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol ConfigurableCell: class {
    static var identifier: String { get }
    func configure(withViewModel viewModel: ListItemViewModelRepresentable)
}

protocol TableController: UITableViewDataSource & UITableViewDelegate {
    
    associatedtype TableCell: ConfigurableCell
    associatedtype ListViewModel: ListViewModelRepresentable
    associatedtype ListItem: ListItemViewModelRepresentable
    
    var selectAction: ((ListItem) -> Void)? { get set }
    init(withViewModel viewModel: ListViewModel)
}
