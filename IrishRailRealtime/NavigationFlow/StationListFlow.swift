//
//  StationListFlow.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationListFlow: NavigationFlow {
    
    private weak var services: Services!
    private weak var navigationController: UINavigationController!
    
    required init(withServices services: Services, navigationController: UINavigationController) {
        self.services = services
        self.navigationController = navigationController
    }
    
    func begin() {
        let stationListViewController = StationListViewController.create(withServices: services, flowDelegate: self)
        navigationController.addChildViewController(stationListViewController)
    }
}

private extension StationListFlow {
    
    func showStationDataViewController(forStation station: StationLink) {
        let stationDataViewController = StationDataViewController.createInstance()
        stationDataViewController.flowDelegate = self
        stationDataViewController.services = services
        stationDataViewController.station = station
        
        navigationController.pushViewController(stationDataViewController, animated: true)
    }
    
}

extension StationListFlow: StationListFlowDelegate {
    
    func selected(station: StationLink) {
        showStationDataViewController(forStation: station)
    }
    
}

extension StationListFlow: StationDataViewControllerFlowDelegate { }
