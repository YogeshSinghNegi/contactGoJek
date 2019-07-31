//
//  ContactListViewController.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 28/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//MARK:- Contact List ViewController Class
class ContactListViewController: UIViewController {
    
    //MARK:- Private Properties
    private var refreshController = UIRefreshControl()
    
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
    
    //MARK:- Action Methods
    @objc func pullToRefreshData() {
        viewModel?.getContactFromApi()
    }
    
    @objc func addButtonTapped() {
        
    }
    
    @objc func groupButtonTapped() {
        print("Group Is Under Development")
    }
}

//MARK:- Extension for Private Methods
extension ContactListViewController {
    
    //MARK:- Setting up initial views
    private func initialSetup() {
        
        setupNavigationView()
        setupTableview()
        setupRefreshController()
    }
    
    //MARK:- Setting up navigationView
    private func setupNavigationView() {
    
        //To make navigation bar clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        //Adding title to navigation
        navigationItem.title = "Contact"
        
        //Adding right add bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
        
        //Adding left group bar button
        let groupBtn = UIBarButtonItem(title: "Group",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.groupButtonTapped))
        groupBtn.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)],
                                         for: .normal)
        navigationItem.leftBarButtonItem = groupBtn
    }
    
    //MARK:- Setting up Tableviews
    private func setupTableview() {
        
        contactListTableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.tintColor = UIColor.black.withAlphaComponent(0.3)
        contactListTableView.registerCell(with: ContactTableViewCell.self)
    }
    
    //MARK:- Setting up RefreshContoller
    private func setupRefreshController() {
        
        refreshController.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
        refreshController.addTarget(self,
                                    action: #selector(pullToRefreshData),
                                    for: UIControl.Event.valueChanged)
        contactListTableView.refreshControl = refreshController
    }
    
    //MARK:- Moving to Viewing single contact
    private func moveToViewController(model: ContactModel) {
        
        let viewContactViewContoller = ViewContactViewContoller.instantiate(fromAppStoryboard: .Main)
        viewContactViewContoller.viewModel = ViewContactViewModel(viewContactDelegate: viewContactViewContoller, contactId: model.contactId)
        self.navigationController?.pushViewController(viewContactViewContoller, animated: true)
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueCell(with: ContactTableViewCell.self)
        if let model = viewModel?.contactList[indexPath.section].value[indexPath.row] {
            listCell.populate(with: model)
        }
        return listCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let model = viewModel?.contactList[indexPath.section].value[indexPath.row] {
            moveToViewController(model: model)
        }
    }
    
    //Belows delegate methods are for shortcut contact access
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

//MARK:- extension for ContactListDelegate
extension ContactListViewController: ContactListDelegate {
    
    func contactsListFetched() {
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
