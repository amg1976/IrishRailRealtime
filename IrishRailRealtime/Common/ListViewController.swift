//
//  ListViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 14/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

class ListViewController<ViewModel: ListViewModelRepresentable, CellType: ConfigurableCell>:
    UIViewController, UITableViewDataSource, UITableViewDelegate, FlowController
    where CellType: UITableViewCell {
    
    @IBOutlet private (set) weak var tableView: UITableView!
    
    private (set) var listViewModel: ListViewModelRepresentable!
    
    weak var services: Services! {
        didSet {
            guard services != nil else { fatalError("Services can't be nil") }
            self.listViewModel = ViewModel(withApiClient: services.apiClient)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard services != nil,
            listViewModel != nil else {
                fatalError("Missing dependencies")
        }
        
        setup()
        reload()
    }
    
    func reload() {
        fatalError("Should be overrided by subclass")
    }
    
    // MARK: - Table Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType else {
            fatalError("Configuration error")
        }
        
        if let viewModel = try? listViewModel.viewModel(atIndexPath: indexPath) {
            cell.configure(withViewModel: viewModel)
        }
        
        return cell
        
    }
    
    // MARK: - Table Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fatalError("Should be overrided by subclass")
    }
    
}

private typealias PrivateApi = ListViewController
private extension PrivateApi {
    
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}