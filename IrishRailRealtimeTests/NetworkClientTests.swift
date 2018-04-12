//
//  IrishRailRealtimeTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble

class NetworkClientTests: XCTestCase {

    var networkClient: SimpleNetworkClient!
    
    override func setUp() {
        self.networkClient = SimpleNetworkClient()
    }
    
    func testCompletionBlockCalledWithInvalidUrlError() {
        
        let expectedError: NetworkClientError = .invalidUrl

        let invalidUrlString: String = ""
        
        networkClient.request(url: invalidUrlString) { (_, error) in
            expect(error).toNot(beNil())
            expect(error!).to(matchError(expectedError))
        }
        
    }
    
    func testCompletionBlockCalledWithInvalidRequestError() {

        let invalidEndpoint: String = "https://api.irishrail.ie/realtime/realtime.asmx/invalid"

        var receivedError: Error?
        
        waitUntil { done in
            self.networkClient.request(url: invalidEndpoint) { (_, error) in
                receivedError = error
                done()
            }
        }
        
        expect(receivedError).toNotEventually(beNil())
        expect({
            if case NetworkClientError.invalidStatusCode(_) = (receivedError as! NetworkClientError) {
                return .succeeded
            }
            return .failed(reason: "Unexpected error case")
        }).to(succeed())
        
    }
    
    func testCompletionBlockCalledWithData() {
        
        let validEndpoint: String = "https://api.irishrail.ie/realtime/realtime.asmx/getAllStationsXML"
        
        var receivedData: Data?
        
        waitUntil { done in
            self.networkClient.request(url: validEndpoint) { (data, _) in
                receivedData = data
                done()
            }
        }
        
        expect(receivedData).notTo(beEmpty())

    }
    
}
