//
//  NavigationFlowTests.swift
//  IrishRailRealtimeTests
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import XCTest
import Nimble
@testable import IrishRailRealtime

class NavigationFlowTests: XCTestCase {

    let services = Services()
    let sourceController = UIViewController()

    func testListFlow() {
    
        let listFlow = StationListFlow(withServices: services, sourceController: sourceController)
        let listFlowDelegate = MockFlowDelegate()
        listFlow.navigationFlowDelegate = listFlowDelegate
        
        listFlow.begin()
        expect(listFlowDelegate.isActive).to(beTrue())
        
        listFlow.selected(station: StationLink(code: "1", name: "Test"))
        expect(listFlowDelegate.isActive).to(beFalse())
        
    }
    
    func testItemFlow() {
        
        let itemFlow = StationItemFlow(withServices: services, sourceController: sourceController)
        let itemFlowDelegate = MockFlowDelegate()
        itemFlow.navigationFlowDelegate = itemFlowDelegate
        
        itemFlow.begin(withStation: StationLink(code: "1", name: "Test"))
        expect(itemFlowDelegate.isActive).to(beTrue())

    }
    
}

class MockFlowDelegate: NavigationFlowDelegate {
    
    var isActive = false
    
    func didBecomeActive(_ flow: NavigationFlow) {
        isActive = true
    }
    
    func didBecomeInactive(_ flow: NavigationFlow) {
        isActive = false
    }
    
}
