//
//  main.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation
import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
let appDelegateClass: AnyClass? = isRunningTests ?
    NSClassFromString("IrishRailRealtimeTests.TestingAppDelegate") :
    NSClassFromString("IrishRailRealtime.AppDelegate")
guard let finalDelegateClass = appDelegateClass else { exit(1) }

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    nil,
    NSStringFromClass(finalDelegateClass)
)
