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
    
    //MARK:- Private Properties
    
    //MARK:- Public Properties
    var viewModel: ContactListViewModelProtocol?
    
    //MARK:- @IBOutlets
    @IBOutlet weak var contactListTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        viewModel?.getContactFromApi()
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
        
        contactListTableView.registerCell(with: ContactTableViewCell.self)
    }
    
}

//MARK:- Extension for TableView Delegate & DataSource
extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.contactList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.contactList[section].value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.contactList[section].key
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueCell(with: ContactTableViewCell.self)
        if let model = viewModel?.contactList[indexPath.section].value[indexPath.row] {
            listCell.populate(with: model)
        }
        return listCell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel?.contactList.compactMap { $0.key }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        //unicode value of title user tapped
        guard let value = UnicodeScalar(title)?.value else {return 0}
        //random value so that it is never picked as no difference will be near to 5000 value if the unicode value is nil
        let strArray = viewModel?.contactList.compactMap { $0.key } ?? []
        let differenceArray = strArray.compactMap({abs(Int(value) - Int(UnicodeScalar($0)?.value ?? 5000))})
        
        return differenceArray.firstIndex(where: {$0 == differenceArray.min()}) ?? 0
    }
}

extension ContactListViewController: ContactListDelegate {
    
    func contactsListFetched() {
        DispatchQueue.main.async {
            self.contactListTableView.reloadData()
        }
    }
    
    func errorOccured(_ errorMessage: String) {
        print(errorMessage)
    }
}
