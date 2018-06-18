//
//  Result.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
enum Result<Element> {
    case succeeded(Element)
    case failed(Error)
}
// swiftlint:enable identifier_name
