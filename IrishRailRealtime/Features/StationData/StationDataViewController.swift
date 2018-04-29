//
//  StationDataViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 29/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class StationDataViewController: UIViewController, ListViewControllerRepresentable {

    typealias ViewModel = StationDataListViewModel
    typealias Controller = StationDataTableController

    @IBOutlet private (set) weak var tableView: UITableView!

    private (set) weak var services: Services! {
        didSet {
            viewModel = StationDataListViewModel(withApiClient: services.apiClient)
        }
    }

    private (set) var viewModel: StationDataListViewModel! {
        didSet {
            tableController = StationDataTableController(withViewModel: viewModel)
        }
    }

    private (set) var tableController: StationDataTableController!
    
    private var station: StationLink!

    // MARK: - Factory method
    
    static func createInstance(withServices services: Services, station: StationLink) -> StationDataViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationDataViewController") as? StationDataViewController else {
                fatalError("Storyboard not properly configured")
        }
        
        controller.services = services
        controller.station = station
        
        return controller
    }

    // MARK: - UIViewController
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reload()
    }

    // MARK: - ListViewControllerRepresentable
    
    func reload() {
        viewModel.loadStationData(withCode: station.code) { result in
            
            switch result {
                
            case .succeeded(let stationDataCount):
                print("Got \(stationDataCount) station data items")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            case .failed(let error):
                DispatchQueue.main.async {
                    self.show(error)
                }
                
            }
        }
    }

}
