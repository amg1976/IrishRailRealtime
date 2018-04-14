//
//  StationDataViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol StationDataViewControllerFlowDelegate: class { }

class StationDataViewController: UIViewController, FlowController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var stationDataListViewModel: StationDataListViewModel!
    
    weak var services: Services! {
        didSet {
            guard services != nil else { fatalError("Services can't be nil") }
            self.stationDataListViewModel = StationDataListViewModel(withApiClient: services.apiClient)
        }
    }
    weak var flowDelegate: StationDataViewControllerFlowDelegate?
    var stationCode: String!
    
    static var instance: StationDataViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationDataViewController") as? StationDataViewController else {
                fatalError("Storyboard not properly configured")
        }
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard services != nil,
            stationDataListViewModel != nil,
            stationCode != nil else {
                fatalError("Missing dependencies")
        }
        
        setup()
        reload()
    }
    
}

extension StationDataViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationDataListViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StationDataCell.reuseIdentifier, for: indexPath) as? StationDataCell else {
            fatalError("Configuration error")
        }
        
        if let stationData = try? stationDataListViewModel.viewModel(atIndexPath: indexPath) {
            cell.configure(withStationData: stationData)
        }
        
        return cell
        
    }
    
}

private typealias PrivateApi = StationDataViewController
private extension PrivateApi {
    
    func setup() {
        tableView.dataSource = self
        tableView.register(StationDataCell.self, forCellReuseIdentifier: StationDataCell.reuseIdentifier)
    }
    
    func reload() {
        stationDataListViewModel.loadStationData(withCode: stationCode) { result in
            
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
    
    func show(_ error: Error) {
        let alertController = UIAlertController(title: "Error loading station data", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }
    
}
