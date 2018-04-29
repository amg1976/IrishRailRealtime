//
//  NavigationFlow.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol NavigationFlow {
    init(withServices services: Services, navigationController: UINavigationController)
    func begin()
}
