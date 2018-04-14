//
//  StationList.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 12/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol StationListViewControllerFlowDelegate: class {
    func didSelectStation()
}

class StationListViewController: UIViewController, FlowController {

    @IBOutlet private weak var tableView: UITableView!
    private var stationListViewModel: StationListViewModel!

    weak var services: Services! {
        didSet {
            guard services != nil else { fatalError("Services can't be nil") }
            self.stationListViewModel = StationListViewModel(withApiClient: services.apiClient)
        }
    }
    weak var flowDelegate: StationListViewControllerFlowDelegate?

    static var instance: StationListViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationListViewController") as? StationListViewController else {
            fatalError("Storyboard not properly configured")
        }
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard services != nil,
            stationListViewModel != nil else {
                fatalError("Missing dependencies")
        }
        
        setup()
        reload()
    }
    
}

extension StationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StationListCell.reuseIdentifier, for: indexPath) as? StationListCell else {
            fatalError("Configuration error")
        }
        
        if let model = try? stationListViewModel.viewModel(atIndexPath: indexPath) {
            cell.configure(withStation: model)
        }
        
        return cell
        
    }
    
}

typealias PrivateApi = StationListViewController
private extension PrivateApi {
    
    func setup() {
        tableView.dataSource = self
        tableView.register(StationListCell.self, forCellReuseIdentifier: StationListCell.reuseIdentifier)
    }
    
    func reload() {
        stationListViewModel.loadStations { result in
            
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
    
    func show(_ error: Error) {
        let alertController = UIAlertController(title: "Error loading stations", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
}
