//
//  StationDataTableController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationDataTableController: NSObject, TableController {
    
    typealias TableCell = StationDataCell
    typealias ListViewModel = StationDataListViewModel
    typealias ListItem = StationDataViewModel

    private weak var viewModel: StationDataListViewModel!
    
    var selectAction: ((StationDataViewModel) -> Void)?
    
    required init(withViewModel viewModel: StationDataListViewModel) {
        self.viewModel = viewModel
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        if let itemViewModel = (try? viewModel.viewModel(atIndexPath: indexPath)) as? ListItem {
            cell.configure(withViewModel: itemViewModel)
        }
        
        return cell
    }    
    
}
