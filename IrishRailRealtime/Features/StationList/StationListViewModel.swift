//
//  StationListViewModel.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

struct StationViewModel: ListItemViewModelRepresentable {
    
    let name: String
    let code: String
    
    init(withModel station: Station) {
        self.code = station.code
        self.name = station.description
    }
    
}

enum StationListViewModelError: Error {
    case invalidIndexPath
}

class StationListViewModel: ListViewModelRepresentable {
    
    private let apiClient: ApiClient
    private var stations: [StationViewModel] = []

    var count: Int {
        return stations.count
    }
    
    required init(withApiClient apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    func loadStations(onCompletion completion: @escaping (Result<Int>) -> Void) {
        apiClient.getStations { [weak self] stationsResult in
            
            switch stationsResult {

            case .succeeded(let stationsList):
                self?.stations = stationsList
                    .map { StationViewModel(withModel: $0) }
                    .sorted(by: { $0.name.compare($1.name) == .orderedAscending  })
                completion(.succeeded(stationsList.count))
                
            case .failed(let error):
                completion(.failed(error))
            }
            
        }
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) throws -> ListItemViewModelRepresentable {

        guard 0..<count ~= indexPath.row else {
            throw StationListViewModelError.invalidIndexPath
        }
        
        return stations[indexPath.row]
        
    }
    
}
