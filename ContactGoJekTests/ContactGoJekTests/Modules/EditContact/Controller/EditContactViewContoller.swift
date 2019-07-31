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
    var viewModel: EditContactViewModelProtocol?
    weak var delegate: ViewContactVCDelegate?
    var pageState: ContactPageState = .add
    
    enum ContactPageState {
        case edit, add
    }
    
    //MARK:- @IBOutlets
    @IBOutlet weak var contactListTableView: UITableView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        viewModel?.getContactFromApi()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc func pullToRefreshData() {
        viewModel?.getContactFromApi()
    }
    
    @objc func cancelButtonTapped() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        view.endEditing(true)
        
        if pageState == .add {
            viewModel?.addContactUsingApi()
        } else {
            viewModel?.updateContactUsingApi()
        }
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
}

//MARK:- Extension for TableView Delegate & DataSource
extension EditContactViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.contactList == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueCell(with: ContactViewHeader.self)
        if let model = viewModel?.contactList {
            header.populateForEdit(model: model)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let listCell = tableView.dequeueCell(with: GetConactDataCellTableViewCell.self)
        if let model = viewModel?.contactList {
            listCell.populateForEditContact(model: model, index: indexPath.row)
            listCell.enterField.delegate = self
        }
        return listCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
}

extension EditContactViewContoller: EditContactDelegate {
    
    func contactAdded() {
        delegate?.newContactAdded()
        dismiss(animated: true, completion: nil)
    }
    
    func contactUpdated() {
        guard let model = viewModel?.contactList else { return }
        delegate?.contactUpdated(contact: model)
        dismiss(animated: true, completion: nil)
    }
    
    func contactFetched() {
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.contactListTableView.reloadData()
        }
        guard let model = viewModel?.contactList else { return }
        delegate?.contactUpdated(contact: model)
    }
    
    func errorOccured(_ errorMessage: String) {
        print(errorMessage)
        DispatchQueue.main.async {
            self.refreshController.endRefreshing()
            self.contactListTableView.reloadData()
        }
    }
}

extension EditContactViewContoller: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let indexPath = textField.tableViewIndexPath(contactListTableView) else { return }
        let text = (textField.text ?? "").byRemovingLeadingTrailingWhiteSpaces
        
        guard let model = viewModel?.contactList else { return }
        var newModel = model
        switch indexPath.row{
        case 0 :
            newModel.firstName = text
        case 1:
            newModel.lastName = text
        case 2:
            newModel.phoneNumber = text
        case 3:
            newModel.email = text
        default:
            break
        }
        viewModel?.contactList = newModel
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let indexPath = textField.tableViewIndexPath(contactListTableView){
            let nextIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            
            let cell = contactListTableView.cellForRow(at: indexPath) as? GetConactDataCellTableViewCell
            let nextCell = contactListTableView.cellForRow(at: nextIndex) as? GetConactDataCellTableViewCell
            
            if textField.returnKeyType == .done {
                cell?.enterField.resignFirstResponder()
            } else {
                cell?.enterField.resignFirstResponder()
                nextCell?.enterField.becomeFirstResponder()
            }
        }
        return true
    }
}
