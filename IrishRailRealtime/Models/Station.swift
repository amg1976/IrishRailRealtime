//
//  Station.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation
import SWXMLHash

struct Station: XMLIndexerDeserializable {
    let description: String
    
    static func deserialize(_ node: XMLIndexer) throws -> Station {
        return Station(
            description: ((try? node["StationDesc"].value()) ?? "description not found")
        )
    }
}

typealias StationList = [Station]
