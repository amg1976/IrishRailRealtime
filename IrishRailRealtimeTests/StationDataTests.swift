//
//  StationDataTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble

class StationDataTests: XCTestCase {
    
    func testCanHandleStationDataError() {
        
        let expectedError: NSError = NSError(domain: "com.amg.error", code: 1000, userInfo: nil)
        
        let apiClient = ApiClient(withNetworkClient: MockErrorNetworkClient())
        
        var receivedResult: Result<StationDataList>?
        
        waitUntil { done in
            apiClient.getStationData(byCode: "bbrdg") { result in
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
        
        let expectedStationDataCount: Int = 3
        
        let apiClient = ApiClient(withNetworkClient: MockStationDataNetworkClient())
        
        var receivedResult: Result<StationDataList>?
        
        waitUntil { done in
            apiClient.getStationData(byCode: "bbrdg") { result in
                receivedResult = result
                done()
            }
        }
        
        expect(receivedResult).toNot(beNil())
        if case let .succeeded(stationDataList) = receivedResult! {
            expect(stationDataList.count).to(equal(expectedStationDataCount))
            expect(stationDataList.first!.origin).to(equal("Dublin Pearse"))
            expect(stationDataList.last!.destination).to(equal("Dublin Pearse"))
        } else {
            fail()
        }
        
    }
    
    func testCanParseInvalidStationData() {
        
        let expectedStationDataCount: Int = 1
        
        let apiClient = ApiClient(withNetworkClient: MockInvalidStationDataNetworkClient())
        
        var receivedResult: Result<StationDataList>?
        
        waitUntil { done in
            apiClient.getStationData(byCode: "bbrg") { result in
                receivedResult = result
                done()
            }
        }
        
        expect(receivedResult).toNot(beNil())
        if case let .succeeded(stationDataList) = receivedResult! {
            expect(stationDataList.count).to(equal(expectedStationDataCount))
            expect(stationDataList.first!.origin).to(equal("Unable to parse Origin"))
        } else {
            fail()
        }
        
    }
    
}

class MockStationDataNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let data = FileManager.default.contents(atPath: Bundle(for: type(of: self)).path(forResource: "StationData", ofType: "xml")!)!
            onCompletion(data, nil)
        }
    }
    
}

class MockInvalidStationDataNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            let data = FileManager.default.contents(atPath: Bundle(for: type(of: self)).path(forResource: "InvalidStationData", ofType: "xml")!)!
            onCompletion(data, nil)
        }
    }
    
}
