//
//  Services.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

protocol ServicesRepresentable {
    var apiClient: ApiClient { get }
}

class Services: ServicesRepresentable {
    let apiClient: ApiClient = ApiClient(withNetworkClient: SimpleNetworkClient())
}
