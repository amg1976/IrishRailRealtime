//
//  StationDataCell.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationDataCell: UITableViewCell {

    static let reuseIdentifier: String = String(describing: self)
    
    func configure(withStationData stationData: StationDataViewModel) {
        self.textLabel?.text = stationData.dueIn
    }

}
