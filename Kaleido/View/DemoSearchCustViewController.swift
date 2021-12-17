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
    @IBOutlet weak var orderListTableView: UITableView!
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
        if nameTextField.hasText || nameTextField.hasText || self.viewModel.didSelectTimePicker {
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
        orderListTableView.separatorStyle = .none
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
        viewModel.customerOders.addObserver(fireNow: false) {[weak self] (newCustomsData) in
            DispatchQueue.main.async {
                self?.orderListTableView.reloadData()
            }
        }
        viewModel.customerData.addObserver(fireNow: false) {[weak self] (customer) in
            self?.nameTextField.text = customer.full_name
            self?.phoneTextField.text = customer.phone_number
            if let birthStr = customer.birthday, let birthDate = birthStr.toDate() {
                self?.datePicker.setDate(birthDate, animated: false)
                self?.viewModel.didSelectTimePicker = true
            }
        }
    }
    
    override func removeBinding() {
        viewModel.customerData.removeObserver()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DemoSelectMainViewController {
            let demoMainVC = segue.destination as! DemoSelectMainViewController
            guard let index = self.orderListTableView.indexPathForSelectedRow
            else {
                    return
            }
            let selectedOrder = self.viewModel.customerOders.value[index.row]
            demoMainVC.setOrderInfo(data: selectedOrder)
        }
    }
}


extension DemoSearchCustViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderListTableView.delegate = self
        self.orderListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCustomsListCell", for: indexPath)
        let foundOrders = viewModel.customerOders.value
        let index = indexPath.row
        let order = foundOrders[index]
        guard let createDate = order.created_at else {
            return cell
        }
        let nameText : UILabel = cell.contentView.viewWithTag(1) as! UILabel
        nameText.text = createDate.toYearMonthDayStr()
        //點兩下
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)
        //預設cell backtground color 選成deftault才能控制selectedBackground
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().titleRed)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    @IBAction func handleDoubleTap(_ sender: Any){
        performSegue(withIdentifier: "toDemoMainView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allTableCellCount = viewModel.customerOders.value.count
        return allTableCellCount
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 8
        let cellHight = orderListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCustomer: Customer = self.viewModel.customerData.value
        self.nameTextField.text = selectedCustomer.full_name
        self.phoneTextField.text = selectedCustomer.phone_number
        if let birthStr = selectedCustomer.birthday, let birthDate = birthStr.toDate() {
            self.datePicker.setDate(birthDate, animated: false)
            self.viewModel.didSelectTimePicker = true
        }
    }
}


