//
//  StationListTableController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationListTableController: NSObject, TableController {
    
    typealias TableCell = StationListCell
    typealias ListViewModel = StationListViewModel
    typealias ListItem = StationViewModel
    
    private weak var viewModel: StationListViewModel!
    
    var selectAction: ((ListItem) -> Void)?
    
    required init(withViewModel viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        if let itemViewModel = try? viewModel.viewModel(atIndexPath: indexPath) {
            cell.configure(withViewModel: itemViewModel)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = (try? viewModel.viewModel(atIndexPath: indexPath)) as? StationViewModel else { return }
        selectAction?(item)
    }
    
}
