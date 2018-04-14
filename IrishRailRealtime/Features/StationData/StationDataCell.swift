//
//  StationDataCell.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationDataCell: UITableViewCell, ConfigurableCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBOutlet private weak var routeLabel: UILabel!
    @IBOutlet private weak var dueInLabel: UILabel!

    func configure(withViewModel viewModel: ListItemViewModelRepresentable) {
        guard let stationData = viewModel as? StationDataViewModel else { return }
        self.routeLabel?.text = stationData.route
        self.dueInLabel?.text = stationData.dueIn
    }

}
