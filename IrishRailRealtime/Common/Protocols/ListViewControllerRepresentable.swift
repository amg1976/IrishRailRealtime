//
//  ListViewControllerRepresentable.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol ListItemViewModelRepresentable { }

protocol ListViewModelRepresentable: class {
    var count: Int { get }
    init(withApiClient apiClient: ApiClient)
    func viewModel(atIndexPath indexPath: IndexPath) throws -> ListItemViewModelRepresentable
}

protocol ListViewControllerRepresentable {
    
    associatedtype ViewModel: ListViewModelRepresentable
    associatedtype Controller: TableController
    
    var tableView: UITableView! { get }
    var tableController: Controller! { get }
    var viewModel: ViewModel! { get }
    var services: Services! { get }
    
    func reload()
    func setup()
}

extension ListViewControllerRepresentable {
    
    func setup() {
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}
