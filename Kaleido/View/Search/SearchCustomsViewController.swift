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
    
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
    }
    
    @IBAction func searchAct(_ sender: Any)
    {
        if nameTextField.hasText || phoneTextField.hasText || self.viewModel.didSelectTimePicker {
            guard
                let name = nameTextField.text,
                let phone = phoneTextField.text else {
                    return
                }
            var birth = datePicker.date.toYearMonthDayStr()
            if !self.viewModel.didSelectTimePicker {
                birth = ""
            }
            controller.tryGetDataFromDb(name: name, phone: phone, birthday: birth)
        } else {
            controller.tryGetDataFromDb()
        }
        
    }
    @IBAction func addNewAct(_ sender: Any)
    {
        guard
            let nameData = nameTextField.text,
            let phoneData = phoneTextField.text
        else{
             return
        }
        let birthData = datePicker.date.toYearMonthDayStr()
        if nameData != "" && phoneData != "" {
            controller.setDataToDb(name: nameData, phone: phoneData, birth: birthData)
        }
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
            DispatchQueue.main.async {
                self?.customsListTableView.reloadData()
            }
        }
    }
    
    override func removeBinding() {
        viewModel.customDataModel.removeObserver()
    }
    
    func toOrderDetailView() {
        guard let selectedService = selectedSlashService else {
            performSegue(withIdentifier: "toKeratinOrder", sender: self)
            return
        }
        performSegue(withIdentifier: "toSlashOrder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
        let birthText : UITextField = cell.contentView.viewWithTag(2) as! UITextField
        let foundCustoms = viewModel.customDataModel.value
//        let index = foundCustoms.index(foundCustoms.startIndex, offsetBy: indexPath.row)
        let index = indexPath.row
        
        let customerDetail = foundCustoms[index]
        let name = customerDetail.full_name
        let birth = customerDetail.birthday
        
        nameText.text = name
        birthText.text = birth
        if let brithday = customerDetail.birthday,
           let setDate:Date = brithday.toDate()
        {
            datePicker.setDate(setDate, animated: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allTableCellCount = viewModel.customDataModel.value.count
        return allTableCellCount
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHight = customsListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        let nameInCell : UITextField = selectedCell.contentView.viewWithTag(1) as! UITextField
        let phoneInCell : UITextField = selectedCell.contentView.viewWithTag(2) as! UITextField
        self.nameTextField.text = nameInCell.text
        self.phoneTextField.text = phoneInCell.text
        self.toOrderDetailView()
    }
}


