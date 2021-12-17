//
//  DemoSearchCustViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import UIKit

class DemoSearchCustViewController: BaseViewController{
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleView: UIView!
    //props
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var birthBackground: UIView!
    @IBOutlet weak var customsListTableView: UITableView!
    var viewModel: DemoSearchCustModel {
        return controller.viewModel
    }
    var controller: DemoSearchCustController = DemoSearchCustController()
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        if Calendar.current.isDateInToday(sender.date) {
            self.viewModel.didSelectTimePicker = false
        } else {
            self.viewModel.didSelectTimePicker = true
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func searchAct(_ sender: Any)
    {
        self.tryGetCustomerData()
    }
    
    private func tryGetCustomerData() {
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
        var birth = datePicker.date.toYearMonthDayStr()
        if !self.viewModel.didSelectTimePicker {
            birth = ""
        }
        if nameData != "" && phoneData != "" &&  birth != ""{
            controller.setDataToDb(name: nameData, phone: phoneData, birth: birth)
        }
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        datePicker.backgroundColor = .white
        searchBtn.layer.cornerRadius = BigBtnCornerRadius
        nameTextField.layer.cornerRadius = textFieldCornerRadius
        phoneTextField.layer.cornerRadius = textFieldCornerRadius
        birthBackground.layer.cornerRadius = textFieldCornerRadius
        customsListTableView.separatorStyle = .none
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
        viewModel.customDataModel.addObserver(fireNow: false) {[weak self] (newCustomsData) in
            DispatchQueue.main.async {
                self?.customsListTableView.reloadData()
            }
        }
    }
    
    override func removeBinding() {
        viewModel.customDataModel.removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is KeratinOrderViewController {
            let keratin = segue.destination as! KeratinOrderViewController
            guard let customerId = self.viewModel.selectedCustomerId else {
                return
            }
            keratin.setOrderInfo(cId: customerId)
        }
    }
}


extension DemoSearchCustViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customsListTableView.delegate = self
        self.customsListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCustomsListCell", for: indexPath)
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
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allTableCellCount = viewModel.customDataModel.value.count
        return allTableCellCount
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 8
        let cellHight = customsListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer: Customer = self.viewModel.customDataModel.value[indexPath.row]
        
        self.nameTextField.text = selectedCustomer.full_name
        self.phoneTextField.text = selectedCustomer.phone_number
        if let birthStr = selectedCustomer.birthday, let birthDate = birthStr.toDate() {
            self.datePicker.setDate(birthDate, animated: false)
            self.viewModel.didSelectTimePicker = true
        }
        performSegue(withIdentifier: "toDemoMainView", sender: self)
    }
}


