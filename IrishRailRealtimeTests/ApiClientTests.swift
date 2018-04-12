//
//  ApiClientTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble

class ApiClientTests: XCTestCase {
    
    func testCanHandleStationsError() {
        
        let expectedError: NSError = NSError(domain: "com.amg.error", code: 1000, userInfo: nil)
        
        let apiClient = ApiClient(withNetworkClient: MockErrorNetworkClient())
        
        var receivedResult: Result<StationList>?
        
        apiClient.getStations { result in
            receivedResult = result
        }
        
        expect(receivedResult).toNotEventually(beNil())
        if case let .failed(error) = receivedResult! {
            expect(error).to(matchError(expectedError))
        } else {
            fail()
        }

    }
    
    func testCanParseStations() {

        let expectedStationsCount: Int = 0
        
        let apiClient = ApiClient(withNetworkClient: MockNetworkClient())
        
        var receivedResult: Result<StationList>?

        apiClient.getStations { result in
            receivedResult = result
        }
        
        expect(receivedResult).toNotEventually(beNil())
        if case let .succeeded(stationList) = receivedResult! {
            expect(stationList.count).to(equal(expectedStationsCount))
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

class MockNetworkClient: NetworkClientRepresentable {
    
    func request(url: String, method: HttpMethod, onCompletion: @escaping NetworkRequestCompletionBlock) {
        DispatchQueue.global(qos: .background).async {
            onCompletion("""
                <ArrayOfObjStation
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                    xmlns="http://api.irishrail.ie/realtime/">
                <objStation>
                <StationDesc>Belfast Central</StationDesc>
                <StationAlias />
                <StationLatitude>54.6123</StationLatitude>
                <StationLongitude>-5.91744</StationLongitude>
                <StationCode>BFSTC</StationCode>
                <StationId>228</StationId>
                </objStation>
                <objStation>
                <StationDesc>Lisburn</StationDesc>
                <StationAlias />
                <StationLatitude>54.514</StationLatitude>
                <StationLongitude>-6.04327</StationLongitude>
                <StationCode>LBURN</StationCode>
                <StationId>238</StationId>
                </objStation>
                <objStation>
                <StationDesc>Lurgan</StationDesc>
                <StationAlias />
                <StationLatitude>54.4672</StationLatitude>
                <StationLongitude>-6.33547</StationLongitude>
                <StationCode>LURGN</StationCode>
                <StationId>241</StationId>
                </objStation>
                <objStation>
                </ArrayOfObjStation>
                """.data(using: .utf8), nil)
        }
    }
    
}
