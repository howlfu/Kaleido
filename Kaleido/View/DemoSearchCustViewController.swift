//
//  DemoSearchCustViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import UIKit

class DemoSearchCustViewController: BaseViewController, UITextFieldDelegate {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleView: UIView!
    //props
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var demoBtn: UIButton!
    @IBOutlet weak var favorite: UIButton!
    
    @IBOutlet weak var birthBackground: UIView!
    @IBOutlet weak var orderListTableView: UITableView!
    var selectedCustomerId: Int32?
    var didSelectTimePicker: Bool = false
    var selectedOrderId: Int32?
    var viewModel: DemoSearchCustViewModel = DemoSearchCustViewModel()
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        if Calendar.current.isDateInToday(sender.date) {
            self.didSelectTimePicker = false
        } else {
            self.didSelectTimePicker = true
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func searchAct(_ sender: Any)
    {
        self.tryGetCustomerData()
    }
    @IBAction func demoAct(_ sender: Any) {
    }
    @IBAction func favoriteAct(_ sender: Any) {
    }
    
    private func tryGetCustomerData() {
        if nameTextField.hasText || phoneTextField.hasText || self.didSelectTimePicker {
            guard
                let name = nameTextField.text,
                let phone = phoneTextField.text else {
                    return
                }
            var birth = datePicker.date.toYearMonthDayStr()
            if !self.didSelectTimePicker {
                birth = ""
            }
            viewModel.tryGetDataFromDb(name: name, phone: phone, birthday: birth)
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
        demoBtn.layer.cornerRadius = BigBtnCornerRadius
        favorite.layer.cornerRadius = BigBtnCornerRadius
        orderListTableView.separatorStyle = .none
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
        viewModel.customerOderClosure = {[weak self] (newCustomsData) in
            DispatchQueue.main.async {
                self?.orderListTableView.reloadData()
            }
        }
        viewModel.customerDataClosure = { [weak self] (customer) in
            self?.nameTextField.text = customer.full_name
            self?.phoneTextField.text = customer.phone_number
            if let birthStr = customer.birthday, let birthDate = birthStr.toDate() {
                self?.datePicker.setDate(birthDate, animated: false)
                self?.didSelectTimePicker = true
            }
        }
        nameTextField.delegate = self
        phoneTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is DemoSelectMainViewController {
            let demoMainVC = segue.destination as! DemoSelectMainViewController
            guard let index = self.orderListTableView.indexPathForSelectedRow
            else {
                    return
            }
            let selectedOrder = self.viewModel.customerOders[index.row]
            demoMainVC.setOrderInfo(data: selectedOrder)
            if self.selectedOrderId != selectedOrder.id {
                self.selectedOrderId = selectedOrder.id
                CacheService.inst.cacheRemove(by: CacheKeyType.demoBindImg)
            }
            
        }
        
        if segue.destination is DemoShowAllPhotoViewController {
            let showPhotoVC = segue.destination as! DemoShowAllPhotoViewController
            if let cId = self.selectedCustomerId {
                showPhotoVC.setSelectedCustomerId(data: cId)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
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
        let foundOrders = viewModel.customerOders
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
        let allTableCellCount = viewModel.customerOders.count
        return allTableCellCount
    }
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 8
        let cellHight = orderListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCustomer: Customer = self.viewModel.customerData else {
            return
        }
        self.nameTextField.text = selectedCustomer.full_name
        self.phoneTextField.text = selectedCustomer.phone_number
        if let birthStr = selectedCustomer.birthday, let birthDate = birthStr.toDate() {
            self.datePicker.setDate(birthDate, animated: false)
            self.didSelectTimePicker = true
        }
    }
}


