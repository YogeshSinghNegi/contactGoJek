//
//  EditContactViewContoller.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 30/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

//MARK:- Contact List ViewController Class
class EditContactViewContoller: UIViewController {
    
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
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Extension for Private Methods
extension EditContactViewContoller {
    
    //MARK:- Setting up initial views
    private func initialSetup() {
        
        setupNavigationView()
        setupTableview()
        setupRefreshController()
    }
    
    private func setupNavigationView() {
        
        //To make navigation bar clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1)
        navigationItem.title = ""
        
        //Adding left cancel bar button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
        
        //Adding right edit bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
    }
    
    //MARK:- Setting up Tableviews
    private func setupTableview() {
        
        contactListTableView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        contactListTableView.delegate = self
        contactListTableView.dataSource = self
        contactListTableView.tintColor = UIColor.black.withAlphaComponent(0.3)
        contactListTableView.registerCell(with: GetConactDataCellTableViewCell.self)
        contactListTableView.registerCell(with: ContactViewHeader.self)
        contactListTableView.registerCell(with: DeleteContactCell.self)
    }
    
    //MARK:- Setting up RefreshContoller
    private func setupRefreshController() {
        
        refreshController.tintColor = #colorLiteral(red: 0.3599199653, green: 0.9019572735, blue: 0.804747045, alpha: 1) //80 227 194
        refreshController.addTarget(self,
                                    action: #selector(pullToRefreshData),
                                    for: UIControl.Event.valueChanged)
        contactListTableView.refreshControl = refreshController
    }
    
    private func openMessage() {
        guard let model = viewModel?.contactList,
            let strURL = "sms:\(model.phoneNumber)&body=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: strURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func openMail() {
        if let model = viewModel?.contactList,
            let emailURL = URL(string: "mailto:\(model.email)"), UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
}

//MARK:- Extension for TableView Delegate & DataSource
extension EditContactViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let header = tableView.dequeueCell(with: ContactViewHeader.self)
            if let model = viewModel?.contactList {
                header.populateViews(model: model)
                header.messageActionTaken = {
                    
                }
                header.callActionTaken = {
                    
                }
                header.emailActionTaken = {
                    
                }
                header.favUnfavActionTaken = {
                    
                }
            }
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let listCell = tableView.dequeueCell(with: GetConactDataCellTableViewCell.self)
            if let model = viewModel?.contactList {
                listCell.populateForViewContact(model: model, index: indexPath.row)
            }
            return listCell
        } else {
            let deleteCell = tableView.dequeueCell(with: DeleteContactCell.self)
            deleteCell.deleteActionTaken = {
                
            }
            return deleteCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : CGFloat.leastNormalMagnitude
    }
}

extension EditContactViewContoller: EditContactDelegate {
    
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
