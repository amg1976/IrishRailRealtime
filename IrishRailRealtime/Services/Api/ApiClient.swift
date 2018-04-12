//
//  ApiClient.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

enum Result<Element> {
    case succeeded(Element)
    case failed(Error)
}

struct ApiClient {
    
    private let networkClient: NetworkClientRepresentable
    
    init(withNetworkClient networkClient: NetworkClientRepresentable) {
        self.networkClient = networkClient
    }
    
    func getStations(onCompletion: @escaping (Result<StationList>) -> Void) {
        
        let url: String = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        
        networkClient.request(url: url, method: .get) { (_, error) in
            
            guard error == nil else {
                onCompletion(Result.failed(error!))
                return
            }
            
            onCompletion(Result.succeeded(StationList()))
            
        }
        
    }

}
