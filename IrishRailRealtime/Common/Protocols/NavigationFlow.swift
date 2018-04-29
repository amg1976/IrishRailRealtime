//
//  NavigationFlow.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol NavigationFlowDelegate: class {
    func didBecomeActive(_ flow: NavigationFlow)
    func didBecomeInactive(_ flow: NavigationFlow)
}

protocol NavigationFlow {
    var navigationFlowDelegate: NavigationFlowDelegate? { get set }
    init(withServices services: Services, sourceController: UIViewController)
}
