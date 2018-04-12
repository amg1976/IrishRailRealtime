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
    let identifier: Int
    let code: String
    let description: String
    let alias: String?
    let latitude: Double
    let longitude: Double
    
    static func deserialize(_ node: XMLIndexer) throws -> Station {
        return Station(
            identifier: ((try? node["StationId"].value()) ?? -1),
            code: ((try? node["StationCode"].value()) ?? "Unable to parse StationCode"),
            description: ((try? node["StationDesc"].value()) ?? "Unable to parse StationDesc"),
            alias: try? node["StationAlias"].value(),
            latitude: ((try? node["StationLatitude"].value()) ?? -999),
            longitude: ((try? node["StationLongitude"].value()) ?? -999)
        )
    }
}

typealias StationList = [Station]
