//
//  StationDataViewModelTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble
@testable import IrishRailRealtime

class StationDataViewModelTests: XCTestCase {
    
    func testCanReturnCount() {
        
        let expectedCount: Int = 3
        
        let viewModel = StationDataListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationDataNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        viewModel.loadStationData(withCode: "bbrg") { _ in
            //empty
        }
        
        expect(viewModel.count).toEventually(equal(expectedCount))
        
    }
    
    func testCanGetElementAtIndexPath() {
        
        let expectedRoute: String = "Maynooth > Dublin Pearse"
        
        let viewModel = StationDataListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationDataNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        waitUntil { done in
            viewModel.loadStationData(withCode: "bbrg") { _ in
                done()
            }
        }
        
        do {
            if let model = try viewModel.viewModel(atIndexPath: IndexPath(row: 0, section: 0)) as? StationDataViewModel {
                expect(model.route).to(equal(expectedRoute))
            } else {
                fail()
            }
            
        } catch {
            fail()
        }
        
    }
    
    func testGetElementAtInvalidIndexPathThrows() {
        
        let viewModel = StationDataListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationDataNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        waitUntil { done in
            viewModel.loadStationData(withCode: "bbrg") { _ in
                done()
            }
        }
        
        expect { try viewModel.viewModel(atIndexPath: IndexPath(row: -1, section: 0)) }.to(throwError())
        
    }
    
}
