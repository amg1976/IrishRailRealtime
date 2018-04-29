//
//  StationList2ViewController.swift
//  IrishRailRealtime
//
//  Created by Adriano Goncalves on 28/04/2018.
//  Copyright © 2018 Adriano Goncalves. All rights reserved.
//

import UIKit

protocol TableController: UITableViewDataSource & UITableViewDelegate {
    
    associatedtype TableCell: ConfigurableCell
    associatedtype ListViewModel: ListViewModelRepresentable
    associatedtype ListItem: ListItemViewModelRepresentable
    
    var selectAction: ((ListItem) -> Void)? { get set }
    init(withViewModel viewModel: ListViewModel)
}

protocol ListViewControllerRepresentable {
    
    associatedtype ViewModel: ListViewModelRepresentable
    associatedtype Controller: TableController
    
    var tableView: UITableView! { get }
    var tableController: Controller! { get }
    var viewModel: ViewModel! { get }
    var services: Services! { get }
    
    func reload()
    func setup()
}

extension ListViewControllerRepresentable {
    
    func setup() {
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

class StationListTableController: NSObject, TableController {

    typealias TableCell = StationListCell
    typealias ListViewModel = StationListViewModel
    typealias ListItem = StationViewModel
    
    private weak var viewModel: StationListViewModel!
    
    var selectAction: ((ListItem) -> Void)?
    
    required init(withViewModel viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        if let itemViewModel = try? viewModel.viewModel(atIndexPath: indexPath) {
            cell.configure(withViewModel: itemViewModel)
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = (try? viewModel.viewModel(atIndexPath: indexPath)) as? StationViewModel else { return }
        selectAction?(item)
    }

}

typealias StationLink = (code: String, name: String)

protocol StationListFlowDelegate: class {
    func selected(station: StationLink)
}

class StationListViewController: UIViewController, ListViewControllerRepresentable {

    private weak var flowDelegate: StationListFlowDelegate?

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
                self.flowDelegate?.selected(station: link)
            }
            self.tableController = tableController
        }
    }
    
    // MARK: - Class factory
    
    static func create(withServices services: Services, flowDelegate: StationListFlowDelegate) -> StationListViewController {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "StationListViewController") as? StationListViewController else {
                fatalError("Storyboard not properly configured")
        }
        
        controller.services = services
        controller.flowDelegate = flowDelegate
        
        return controller
    }

    // MARK: - UIViewController
    
    override private init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
