//
//  MainViewController.swift
//  BitcoinRate
//
//  Created by Nataniel Martin on 08/05/2018.
//  Copyright © 2018 Nataniel Martin. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    var viewModel = MainViewModel()
    
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.delegate = self
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.register(HistoryRateCell.self)
        self.addRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAction()
    }
    
    func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        self.historyTableView.refreshControl = refreshControl
    }
    
    @objc private func refreshAction() {
        viewModel.getCurrentRate()
        viewModel.getHistoryRates()
    }
}

// MARK: MainViewModel Delegates

extension MainViewController: MainViewModelDelegate {
    func mainViewModel(model: MainViewModel, update headerViewModel: HeaderViewModel) {
        self.headerView.configure(with: headerViewModel)
    }
   
    func mainViewModelDidUpdateHistory(model: MainViewModel) {
        self.historyTableView.refreshControl?.endRefreshing()
        self.historyTableView.reloadData()
    }
    
    func mainViewModel(model: MainViewModel, showError error: BRError) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ALERT_OK_ACTION_TITLE".localized, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITableView Delegates / Datasources

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.totalRates
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HistoryRateCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let model = self.viewModel.historyCellModel(for: indexPath)
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History rate"
    }
}

