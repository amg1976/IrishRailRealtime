//
//  StationListCell.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationListCell: UITableViewCell {

    static let reuseIdentifier: String = String(describing: self)
    
    func configure(withStation station: StationViewModel) {
        self.textLabel?.text = station.name
    }
}
