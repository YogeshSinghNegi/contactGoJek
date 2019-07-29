//
//  ContactListViewController.swift
//  ContactGoJekTests
//
//  Created by Aishwarya Rastogi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//MARK:- Contact List ViewController Class
class ContactListViewController: UIViewController {
    
    //MARK:- Public Properties
    var viewModel: ContactListViewModelProtocol?
    
    //MARK:- @IBOutlets
    @IBOutlet weak var contactListTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        self.viewModel?.getContactFromApi()
    }
}

//MARK:- Extension for Private Methods
extension ContactListViewController {
    
    //MARK:- Setting up initial views
    private func initialSetup() {
        
        setupTableview()
    }
    
    //MARK:- Setting up Tableviews
    private func setupTableview() {
        
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.registerCell(with: ContactTableViewCell.self)
    }
    
}

//MARK:- Extension for TableView Delegate & DataSource
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.contactList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.contactList[section].value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.viewModel?.contactList[section].key
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueCell(with: ContactTableViewCell.self)
        if let model = self.viewModel?.contactList[indexPath.section].value[indexPath.row] {
            listCell.populate(with: model)
        }
        return listCell
    }
}

extension ContactListViewController: ContactListDelegate {
    func contactsListFetched() {
        DispatchQueue.main.async {
            self.contactListTableView.reloadData()
        }
    }
    
    func errorOccured(_ errorMessage: String) {
        
    }
    
    
}
