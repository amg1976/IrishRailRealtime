//
//  StationDataListViewModel.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

struct StationDataViewModel {
    
    let origin: String
    let destination: String
    let dueIn: String
    
    init(withModel stationData: StationData) {
        self.origin = stationData.origin
        self.destination = stationData.destination
        self.dueIn = "\(stationData.dueIn)"
    }

}

enum StationDataListViewModelError: Error {
    case invalidIndexPath
}

class StationDataListViewModel {

    private let apiClient: ApiClient
    private var stationData: [StationDataViewModel] = []
    
    var count: Int {
        return stationData.count
    }

    init(withApiClient apiClient: ApiClient = ApiClient()) {
        self.apiClient = apiClient
    }

    func loadStationData(withCode code: String, onCompletion completion: @escaping (Result<Int>) -> Void) {
        apiClient.getStationData(byCode: code, onCompletion: { [weak self] stationDataResult in
            
            switch stationDataResult {
                
            case .succeeded(let stationDataList):
                self?.stationData = stationDataList
                    .map { StationDataViewModel(withModel: $0) }
                    .sorted(by: { $0.dueIn.compare($1.dueIn) == .orderedAscending  })
                completion(.succeeded(stationDataList.count))
                
            case .failed(let error):
                completion(.failed(error))
            }
            
        })
    }
    
    func viewModel(atIndexPath indexPath: IndexPath) throws -> StationDataViewModel {
        
        guard 0..<count ~= indexPath.row else {
            throw StationDataListViewModelError.invalidIndexPath
        }
        
        return stationData[indexPath.row]
        
    }
    
}
