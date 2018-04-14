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
    
    func getStations(onCompletion completion: @escaping (Result<StationList>) -> Void) {
        
        let url: String = "http://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        
        networkClient.request(url: url, method: .get) { (data, error) in
            
            guard error == nil else {
                completion(Result.failed(error!))
                return
            }
            
            guard let data = data else {
                completion(Result.succeeded(StationList()))
                return
            }
            
            let xmlObject = SWXMLHash.parse(data)
            
            do {
                let stationList: StationList = try xmlObject["ArrayOfObjStation"]["objStation"].value()
                completion(Result.succeeded(stationList))
            } catch let parseError {
                completion(Result.failed(parseError))
            }
            
        }
        
    }
    
    func getStationData(byCode code: String, onCompletion completion: @escaping (Result<StationDataList>) -> Void) {
        
        let url: String = "http://api.irishrail.ie/realtime/realtime.asmx/getStationDataByCodeXML?StationCode=\(code)"
        
        networkClient.request(url: url, method: .get) { (data, error) in
            
            guard error == nil else {
                completion(Result.failed(error!))
                return
            }
            
            guard let data = data else {
                completion(Result.succeeded(StationDataList()))
                return
            }
            
            let xmlObject = SWXMLHash.parse(data)
            
            do {
                let stationDataList: StationDataList = try xmlObject["ArrayOfObjStationData"]["objStationData"].value()
                completion(Result.succeeded(stationDataList))
            } catch let parseError {
                completion(Result.failed(parseError))
            }
            
        }
        
    }
    
}
