//
//  Result.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation

enum Result<Element> {
    case succeeded(Element)
    case failed(Error)
}
