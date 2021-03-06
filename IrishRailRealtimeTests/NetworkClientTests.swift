//
//  IrishRailRealtimeTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble
@testable import IrishRailRealtime

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

        let expectedStatusCode: Int = 500
        
        let invalidEndpoint: String = "https://api.irishrail.ie/realtime/realtime.asmx/invalid"

        var receivedError: Error?
        
        waitUntil { done in
            self.networkClient.request(url: invalidEndpoint) { (_, error) in
                receivedError = error
                done()
            }
        }
        
        expect(receivedError).toNotEventually(beNil())
        guard let receivedNetworkError = receivedError as? NetworkClientError else {
            fail()
            return
        }
        
        if case let .invalidStatusCode(statusCode) = receivedNetworkError {
            expect(statusCode).to(equal(expectedStatusCode))
        } else {
            fail()
        }
        
    }
    
}
