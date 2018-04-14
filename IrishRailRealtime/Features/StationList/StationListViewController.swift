//
//  StationListViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol StationListViewControllerFlowDelegate: class {
    func didSelectStation(_ stationCode: String)
}

class StationListViewController: ListViewController<StationListViewModel, StationListCell> {

    weak var flowDelegate: StationListViewControllerFlowDelegate?
    
    static var instance: StationListViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationListViewController") as? StationListViewController else {
                fatalError("Storyboard not properly configured")
        }
        return controller
    }

    override func reload() {
        
        guard let stationListViewModel = listViewModel as? StationListViewModel else { return }
        
        stationListViewModel.loadStations { result in
            
            switch result {
                
            case .succeeded(let stationCount):
                print("Got \(stationCount) stations")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failed(let error):
                DispatchQueue.main.async {
                    self.show(error)
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let station = try? listViewModel.viewModel(atIndexPath: indexPath) as? StationViewModel {
            flowDelegate?.didSelectStation(station!.code)
        }
    }

}
