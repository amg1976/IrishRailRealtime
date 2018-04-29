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
    private weak var sourceController: UIViewController!
    
    private var stationItemFlow: StationItemFlow?

    weak var navigationFlowDelegate: NavigationFlowDelegate?

    required init(withServices services: Services, sourceController: UIViewController) {
        self.services = services
        self.sourceController = sourceController
    }
    
    func begin() {
        let stationListViewController = StationListViewController.create(withServices: services, actionDelegate: self)
        (sourceController as? UINavigationController)?.addChildViewController(stationListViewController)
        navigationFlowDelegate?.didBecomeActive(self)
    }
}

extension StationListFlow: StationListActionDelegate {
    
    func selected(station: StationLink) {
        self.stationItemFlow = StationItemFlow(withServices: services, sourceController: sourceController)
        stationItemFlow?.begin(withStation: station)
        navigationFlowDelegate?.didBecomeInactive(self)
    }
    
}
