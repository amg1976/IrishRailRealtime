//
//  StationItemFlow.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationItemFlow: NavigationFlow {
    
    private weak var services: Services!
    private weak var sourceController: UIViewController!
    private var modalNavigationController: UINavigationController?
    
    weak var navigationFlowDelegate: NavigationFlowDelegate?

    required init(withServices services: Services, sourceController: UIViewController) {
        self.services = services
        self.sourceController = sourceController
    }

    func begin(withStation station: StationLink) {

        let stationDataViewController = StationDataViewController.createInstance(withServices: services, station: station)
        
        let newNavigationController = UINavigationController(rootViewController: stationDataViewController)
        stationDataViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped(_:)))
        stationDataViewController.navigationItem.title = station.name

        sourceController.present(newNavigationController, animated: true, completion: nil)
        self.modalNavigationController = newNavigationController
        
        navigationFlowDelegate?.didBecomeActive(self)
    }
    
    @objc
    private func doneButtonTapped(_ sender: UIControl) {
        modalNavigationController?.dismiss(animated: true, completion: nil)
        navigationFlowDelegate?.didBecomeInactive(self)
    }
}
