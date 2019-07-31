//
//  ViewContactViewContoller.swift
//  ContactGoJekTests
//
//  Created by Yogesh Singh Negi on 30/07/19.
//  Copyright © 2019 Yogesh Singh Negi. All rights reserved.
//

import UIKit

protocol ViewContactVCDelegate: AnyObject {
    func contactUpdated(contact: ContactDetailModel)
    func newContactAdded()
    func deleteContact()
}

//MARK:- Contact List ViewController Class
class ViewContactViewContoller: UIViewController {
    
    //MARK:- Private Properties
    private var refreshController = UIRefreshControl()
    
    //MARK:- Public Properties
    var viewModel: ViewContactViewModelProtocol?
    weak var delegate: ViewContactVCDelegate?
    
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
        
        guard let model = viewModel?.contactList else { return }
        let editScene = EditContactViewContoller.instantiate(fromAppStoryboard: .Main)
        editScene.viewModel = EditContactViewModel(EditContactDelegate: editScene, contactList: model)
        editScene.delegate = self
        editScene.pageState = .edit
        let navContoller = UINavigationController(rootViewController: editScene)
        self.present(navContoller, animated: true, completion: nil)
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
        
        //Adding right edit bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                            target: self,
                                                            action: #selector(editButtonTapped))
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
    
    private func openMail() {
        if let model = viewModel?.contactList,
            let emailURL = URL(string: "mailto:\(model.email)"), UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    private func makePhoneCall() {
        if let model = viewModel?.contactList,
            let url = URL(string: "TEL://\(model.phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func hitFavUnFav() {
        guard let model = viewModel?.contactList else { return }
        var newModel = model
        newModel.favorite.toggle()
        viewModel?.updateContactUsingApi(contact: newModel)
    }
}

//MARK:- Extension for TableView Delegate & DataSource
extension ViewContactViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.contactList == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let header = tableView.dequeueCell(with: ContactViewHeader.self)
            if let model = viewModel?.contactList {
                header.populateViews(model: model)
                header.messageActionTaken = { [weak self] in
                    guard let _self = self else { return }
                    _self.openMessage()
                }
                header.callActionTaken = { [weak self] in
                    guard let _self = self else { return }
                    _self.makePhoneCall()
                }
                header.emailActionTaken = { [weak self] in
                    guard let _self = self else { return }
                    _self.openMail()
                }
                header.favUnfavActionTaken = { [weak self] in
                    guard let _self = self else { return }
                    _self.hitFavUnFav()
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
            deleteCell.deleteActionTaken = { [weak self] in
                guard let _self = self else { return }
                _self.viewModel?.deleteContact()
            }
            return deleteCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        viewModel?.deleteContact()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : CGFloat.leastNormalMagnitude
    }
}

extension ViewContactViewContoller: ViewContactDelegate {
    
    func contactFavDone() {
        DispatchQueue.main.async {
            self.contactListTableView.reloadData()
        }
        if let model = viewModel?.contactList {
            self.delegate?.contactUpdated(contact: model)
        }
    }
    
    func contactFetched() {
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.contactListTableView.reloadData()
        }
        if let model = viewModel?.contactList {
            self.delegate?.contactUpdated(contact: model)
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

//MARK:- extension for ViewContactVCDelegate
extension ViewContactViewContoller: ViewContactVCDelegate {
    
    func deleteContact() {
        delegate?.deleteContact()
    }
    
    func newContactAdded() {
        
    }
    
    func contactUpdated(contact: ContactDetailModel) {
        viewModel?.contactList = contact
        if let model = viewModel?.contactList {
            self.delegate?.contactUpdated(contact: model)
        }
        DispatchQueue.main.async {
            self.contactListTableView.reloadData()
        }
    }
}
