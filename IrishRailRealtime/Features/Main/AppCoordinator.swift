//
//  AppCoordinator.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

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
    private var initialFlow: NavigationFlow?
    
    // MARK: - Public methods
    
    /// Initiates the object, setting up the global UIAppearance.
    /// - parameter window: The window where the app will be presented.
    init(onWindow window: UIWindow) {
        self.window = window
    }
    
    /// Starting point for the app flow, makes the window visible and shows the initial view controller.
    func start() {
        let flow = StationListFlow(withServices: services, sourceController: navigationController)
        flow.begin()
        self.initialFlow = flow

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
