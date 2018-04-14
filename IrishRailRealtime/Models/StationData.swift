//
//  StationData.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import Foundation
import SWXMLHash

struct StationData: XMLIndexerDeserializable {
    let origin: String
    let destination: String
    let dueIn: Int
    
    static func deserialize(_ node: XMLIndexer) throws -> StationData {
        return StationData(
            origin: ((try? node["Origin"].value()) ?? "Unable to parse Origin"),
            destination: ((try? node["Destination"].value()) ?? "Unable to parse Destination"),
            dueIn: ((try? node["Duein"].value()) ?? -1)
        )
    }
}

typealias StationDataList = [StationData]
