//
//  StationDataListViewModel.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

struct StationDataViewModel {
    
}

class StationDataListViewModel {

    private let apiClient: ApiClient
    
    init(withApiClient apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    func loadStationData(onCompletion completion: @escaping (Result<Int>) -> Void) {
        
    }
    
}
