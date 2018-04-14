//
//  ApiClientTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble

class StationListTests: XCTestCase {
    
    func testCanHandleStationsError() {
        
        let expectedError: NSError = NSError(domain: "com.amg.error", code: 1000, userInfo: nil)
        
        let apiClient = ApiClient(withNetworkClient: MockErrorNetworkClient())
        
        var receivedResult: Result<StationList>?
        
        waitUntil { done in
            apiClient.getStations { result in
                receivedResult = result
                done()
            }
        }
        
        expect(receivedResult).toNot(beNil())
        if case let .failed(error) = receivedResult! {
            expect(error).to(matchError(expectedError))
        } else {
            fail()
        }

    }
    
    func testCanParseValidStationData() {

        let expectedStationsCount: Int = 3
        
        let apiClient = ApiClient(withNetworkClient: MockStationListNetworkClient())
        
        var receivedResult: Result<StationList>?

        waitUntil { done in
            apiClient.getStations { result in
                receivedResult = result
                done()
            }
        }
        
        expect(receivedResult).toNot(beNil())
        if case let .succeeded(stationList) = receivedResult! {
            expect(stationList.count).to(equal(expectedStationsCount))
            expect(stationList.first!.description).to(equal("Belfast Central"))
            expect(stationList.last!.description).to(equal("Lurgan"))
        } else {
            fail()
        }
        
    }

    func testCanParseInvalidStationData() {
        
        let expectedStationsCount: Int = 1
        
        let apiClient = ApiClient(withNetworkClient: MockInvalidStationListNetworkClient())
        
        var receivedResult: Result<StationList>?
        
        waitUntil { done in
            apiClient.getStations { result in
                receivedResult = result
                done()
            }
        }
        
        expect(receivedResult).toNot(beNil())
        if case let .succeeded(stationList) = receivedResult! {
            expect(stationList.count).to(equal(expectedStationsCount))
            expect(stationList.first!.description).to(equal("Unable to parse StationDesc"))
        } else {
            fail()
        }
        
    }

}

class MockErrorNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            onCompletion(nil, NSError(domain: "com.amg.error", code: 1000, userInfo: nil))
        }
    }
    
}

class MockStationListNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let data = FileManager.default.contents(atPath: Bundle(for: type(of: self)).path(forResource: "StationList", ofType: "xml")!)!
            onCompletion(data, nil)
        }
    }
    
}

class MockInvalidStationListNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let data = FileManager.default.contents(atPath: Bundle(for: type(of: self)).path(forResource: "InvalidStationList", ofType: "xml")!)!
            onCompletion(data, nil)
        }
    }
    
}
