//
//  ApiClient.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation
import SWXMLHash

struct ApiClient {
    
    private let networkClient: NetworkClientRepresentable
    
    init(withNetworkClient networkClient: NetworkClientRepresentable = SimpleNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getStations(onCompletion: @escaping (Result<StationList>) -> Void) {
        
        let url: String = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        
        networkClient.request(url: url, method: .get) { (data, error) in
            
            guard error == nil else {
                onCompletion(Result.failed(error!))
                return
            }
            
            guard let data = data else {
                onCompletion(Result.succeeded(StationList()))
                return
            }
            
            let xmlObject = SWXMLHash.parse(data)
            
            do {
                let stationList: StationList = try xmlObject["ArrayOfObjStation"]["objStation"].value()
                onCompletion(Result.succeeded(stationList))
            } catch let parseError {
                onCompletion(Result.failed(parseError))
            }
            
        }
        
    }

}
