//
//  SearchCustomsViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/1.
//

import UIKit

class SearchCustomsViewController: BaseViewController{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleView: UIView!
    //props
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var addNewBtn: UIButton!
    
    @IBOutlet weak var birthBackground: UIView!
    @IBOutlet weak var customsListTableView: UITableView!
    var viewModel: SearchCustomsModel {
        return controller.viewModel
    }
    var controller: SearchCustomsController = SearchCustomsController()
    let aCellHightOfViewRadio = 8
    @IBAction func searchAct(_ sender: Any)
    {
        controller.tryGetDataFromDb()
    }
    @IBAction func addNewAct(_ sender: Any)
    {
        guard let nameData = nameTextField.text, let phoneData = phoneTextField.text else{
             return
        }
        controller.setDataToDb(name: nameData, phone: phoneData)
    }
    var selectedSlashService: [SlashListType]?
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        datePicker.backgroundColor = .white
        searchBtn.layer.cornerRadius = BigBtnCornerRadius
        addNewBtn.layer.cornerRadius = BigBtnCornerRadius
        nameTextField.layer.cornerRadius = textFieldCornerRadius
        phoneTextField.layer.cornerRadius = textFieldCornerRadius
        birthBackground.layer.cornerRadius = textFieldCornerRadius
        customsListTableView.separatorStyle = .none
    }
    
    override func initBinding() {
        viewModel.customDataModel.addObserver(fireNow: false) {[weak self] (newCustomsData) in
            self?.customsListTableView.reloadData()
        }
    }
    
    override func removeBinding() {
        viewModel.customDataModel.removeObserver()
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        let calendar = Calendar.current
        let tempHour = calendar.component(.hour, from: sender.date)
        let tempMinute = calendar.component(.minute, from: sender.date)

        Swift.print("hour: \(tempHour) minute: \(tempMinute)")
    }
}


extension SearchCustomsViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customsListTableView.delegate = self
        self.customsListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customsListCell", for: indexPath)
        let nameText : UITextField = cell.contentView.viewWithTag(1) as! UITextField
        let phoneText : UITextField = cell.contentView.viewWithTag(2) as! UITextField
        let foundCustoms = viewModel.customDataModel.value
        let index = foundCustoms.index(foundCustoms.startIndex, offsetBy: indexPath.row)
        let name = foundCustoms.keys[index]
        nameText.text = name
        let phoneNumber = foundCustoms[name]
        phoneText.text = phoneNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.customDataModel.value.count
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return customsListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let nameInCell : UITextField = selectedCell.contentView.viewWithTag(1) as! UITextField
        let phoneInCell : UITextField = selectedCell.contentView.viewWithTag(2) as! UITextField
        self.nameTextField.text = nameInCell.text
        self.phoneTextField.text = phoneInCell.text
    }
}

