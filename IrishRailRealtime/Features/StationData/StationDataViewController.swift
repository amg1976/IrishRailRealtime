//
//  StationDataViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol StationDataViewControllerFlowDelegate: class { }

class StationDataViewController: ListViewController<StationDataListViewModel, StationDataCell> {
   
    var station: StationLink!
    weak var flowDelegate: StationDataViewControllerFlowDelegate?
    
    override func viewDidLoad() {
        guard station != nil else {
            fatalError("Missing dependencies")
        }
        super.viewDidLoad()
        
        self.navigationItem.title = station.name
    }
    
    override func reload() {
        guard let stationDataListViewModel = listViewModel as? StationDataListViewModel else { return }
        
        stationDataListViewModel.loadStationData(withCode: station.code) { result in
            
            switch result {
                
            case .succeeded(let stationDataCount):
                print("Got \(stationDataCount) station data items")
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
    
}

extension StationDataViewController {
    
    static func createInstance() -> StationDataViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationDataViewController") as? StationDataViewController else {
                fatalError("Storyboard not properly configured")
        }
        return controller
    }

}
