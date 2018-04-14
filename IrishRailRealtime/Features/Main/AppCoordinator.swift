//
//  AppCoordinator.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol FlowController: class {
    var services: Services! { get set }
}

class Services {
    let apiClient: ApiClient = ApiClient(withNetworkClient: SimpleNetworkClient())
}

/**
 Responsible for handling the navigation between the different screens,
 by setting itself as flow delegate for each view controller.
 Creates the shared services instances and injects them to each view controller.
 */
class AppCoordinator {
    
    // MARK: - Private properties
    
    private weak var window: UIWindow!
    private let navigationController: UINavigationController = UINavigationController()
    private let services: Services = Services()
    
    // MARK: - Public methods
    
    /// Initiates the object, setting up the global UIAppearance.
    /// - parameter window: The window where the app will be presented.
    init(onWindow window: UIWindow) {
        self.window = window
    }
    
    /// Starting point for the app flow, makes the window visible and shows the initial view controller.
    func start() {
        showStationListViewController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
}

private typealias PrivateApi = AppCoordinator
private extension PrivateApi {
    
    func showStationListViewController() {
        let stationListViewController = StationListViewController.instance
        stationListViewController.flowDelegate = self
        stationListViewController.services = services
        
        navigationController.addChildViewController(stationListViewController)
    }
    
    func showStationDataViewController(forStationCode stationCode: String) {
        let stationDataViewController = StationDataViewController.instance
        stationDataViewController.flowDelegate = self
        stationDataViewController.services = services
        stationDataViewController.stationCode = stationCode
        
        navigationController.pushViewController(stationDataViewController, animated: true)
    }

}

extension AppCoordinator: StationListViewControllerFlowDelegate {
    
    func didSelectStation(_ stationCode: String) {
        showStationDataViewController(forStationCode: stationCode)
    }
    
}

extension AppCoordinator: StationDataViewControllerFlowDelegate { }
