//
//  StationListCell.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationListCell: UITableViewCell, ConfigurableCell {
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    
    static var identifier: String {return String(describing: self) }
    
    func configure(withViewModel viewModel: ListItemViewModelRepresentable) {
        guard let station = viewModel as? StationViewModel else { return }
        self.descriptionLabel?.text = station.name
        self.codeLabel?.text = station.code
    }
}
