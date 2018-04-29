//
//  StationListViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 28/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

typealias StationLink = (code: String, name: String)

protocol StationListActionDelegate: class {
    func selected(station: StationLink)
}

class StationListViewController: UIViewController, ListViewControllerRepresentable {

    private weak var actionDelegate: StationListActionDelegate?

    @IBOutlet private (set) weak var tableView: UITableView!

    private (set) var tableController: StationListTableController!

    private (set) weak var services: Services! {
        didSet {
            self.viewModel = StationListViewModel(withApiClient: services.apiClient)
        }
    }
    
    private (set) var viewModel: StationListViewModel! {
        didSet {
            let tableController = StationListTableController(withViewModel: viewModel)
            tableController.selectAction = { [unowned self] item in
                let link = StationLink(code: item.code, name: item.name)
                self.actionDelegate?.selected(station: link)
            }
            self.tableController = tableController
        }
    }
    
    // MARK: - Class factory
    
    static func create(withServices services: Services, actionDelegate: StationListActionDelegate) -> StationListViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationListViewController") as? StationListViewController else {
                fatalError("Storyboard not properly configured")
        }
        
        controller.services = services
        controller.actionDelegate = actionDelegate
        
        return controller
    }

    // MARK: - UIViewController
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reload()
    }
    
    // MARK: - ListViewControllerRepresentable
    
    func reload() {
        viewModel.loadStations { result in
            
            switch result {
                
            case .succeeded(let stationCount):
                print("Got \(stationCount) stations")
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
