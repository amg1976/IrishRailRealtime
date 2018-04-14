//
//  StationListViewModelTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble

class StationListViewModelTests: XCTestCase {
    
    func testCanReturnCount() {
        
        let expectedCount: Int = 3
        
        let viewModel = StationListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationListNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        viewModel.loadStations { _ in
            //empty
        }
        
        expect(viewModel.count).toEventually(equal(expectedCount))
        
    }

    func testCanGetElementAtIndexPath() {
        
        let expectedName: String = "Belfast Central"
        
        let viewModel = StationListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationListNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        waitUntil { done in
            viewModel.loadStations { _ in
                done()
            }
        }
        
        do {
            if let model = try viewModel.viewModel(atIndexPath: IndexPath(row: 0, section: 0)) as? StationViewModel {
                expect(model.name).to(equal(expectedName))
            } else {
                fail()
            }
            
        } catch {
            fail()
        }
        
    }
    
    func testGetElementAtInvalidIndexPathThrows() {

        let viewModel = StationListViewModel(withApiClient: ApiClient(withNetworkClient: MockStationListNetworkClient()))
        
        expect(viewModel.count).to(equal(0))
        
        waitUntil { done in
            viewModel.loadStations { _ in
                done()
            }
        }
        
        expect { try viewModel.viewModel(atIndexPath: IndexPath(row: 10, section: 0)) }.to(throwError())
        
    }

}
