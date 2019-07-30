//
//  ViewContactViewContoller.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 30/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//MARK:- Contact List ViewController Class
class ViewContactViewContoller: UIViewController {
    
    //MARK:- Private Properties
    private var refreshController = UIRefreshControl()
    
    //MARK:- Public Properties
    var viewModel: ViewContactViewModelProtocol?
    
    //MARK:- @IBOutlets
    @IBOutlet weak var contactListTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        viewModel?.getContactFromApi()
    }
    
    @objc func pullToRefreshData() {
        viewModel?.getContactFromApi()
    }
    
    @objc func editButtonTapped() {
        
    }
}

//MARK:- Extension for Private Methods
extension ViewContactViewContoller {
    
    //MARK:- Setting up initial views
    private func initialSetup() {
        
        setupNavigationView()
        setupTableview()
        setupRefreshController()
    }
    
    private func setupNavigationView() {
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)
        navigationItem.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
    }
    
    //MARK:- Setting up Tableviews
    private func setupTableview() {
        
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.tintColor = UIColor.black.withAlphaComponent(0.3)
        contactListTableView.registerCell(with: GetConactDataCellTableViewCell.self)
        contactListTableView.registerCell(with: ContactViewHeader.self)
    }
    
    //MARK:- Setting up RefreshContoller
    private func setupRefreshController() {
        
        refreshController.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
        refreshController.addTarget(self,
                                    action: #selector(pullToRefreshData),
                                    for: UIControl.Event.valueChanged)
        contactListTableView.refreshControl = refreshController
    }
    
}

//MARK:- Extension for TableView Delegate & DataSource
extension ViewContactViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueCell(with: ContactViewHeader.self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueCell(with: GetConactDataCellTableViewCell.self)
        if let model = viewModel?.contactList {
            listCell.populateForViewContact(model: model, index: indexPath.row)
        }
        return listCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 336
    }
}

extension ViewContactViewContoller: ViewContactDelegate {
    
    func contactFetched() {
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.contactListTableView.reloadData()
        }
    }
    
    func errorOccured(_ errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.contactListTableView.reloadData()
        }
    }
}
