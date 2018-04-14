//
//  StationListViewModel.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

struct StationViewModel {
    
    let stationName: String
    
    init(withModel station: Station) {
        self.stationName = "\(station.description) (\(station.code))"
    }
    
}

enum StationListViewModelError: Error {
    case invalidIndexPath
}

class StationListViewModel {
    
    private let apiClient: ApiClient
    private var stations: [StationViewModel] = []

    var count: Int {
        return stations.count
    }
    
    init(withApiClient apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    func loadStations(onCompletion completion: @escaping (Result<Int>) -> Void) {
        apiClient.getStations { [weak self] stationsResult in
            
            switch stationsResult {

            case .succeeded(let stationsList):
                self?.stations = stationsList
                    .map { StationViewModel(withModel: $0) }
                    .sorted(by: { $0.stationName.compare($1.stationName) == .orderedAscending  })
                completion(.succeeded(stationsList.count))
                
            case .failed(let error):
                completion(.failed(error))
            }
            
        }
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) throws -> StationViewModel {
        
        guard 0..<count ~= indexPath.row else {
            throw StationListViewModelError.invalidIndexPath
        }
        
        return stations[indexPath.row]
        
    }
    
}
