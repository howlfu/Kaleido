//
//  OrderRecordViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//

import Foundation
import UIKit


class OrderRecordViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateBackground: UIView!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var orderListTableView: UITableView!
    @IBAction func searchAct(_ sender: Any) {
        self.tryGetCustomerData()
    }
    
    @IBAction func deleteAct(_ sender: Any) {
        guard let indexPath = self.orderListTableView.indexPathForSelectedRow else {
            return
        }
        let foundOrders = viewModel.customerOders.value
        let index = indexPath.row
        let order = foundOrders[index]
        let delOrderId = order.id
        let _ = controller.deleteOrderFromDb(id: delOrderId)
    }
    var controller: OrderRecordController = OrderRecordController()
    var viewModel: OrderRecordModel {
        return controller.viewModel
    }
    public func setNextDest(viewType: otherViewBtnDestType) {
        self.viewModel.btnDestination = viewType
    }
    private func tryGetCustomerData() {
        if nameText.hasText || numberText.hasText || self.viewModel.didSelectTimePicker {
            guard
                let name = nameText.text,
                let phone = numberText.text else {
                    return
                }
            var birth = datePicker.date.toYearMonthDayStr()
            if !self.viewModel.didSelectTimePicker {
                birth = ""
            }
            controller.tryGetDataFromDb(name: name, phone: phone, birthday: birth, getType: self.viewModel.btnDestination)
        }
    }
    
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        nameText.layer.cornerRadius = textFieldCornerRadius
        dateBackground.layer.cornerRadius = textFieldCornerRadius
        numberText.layer.cornerRadius = textFieldCornerRadius
        searchBtn.layer.cornerRadius = BigBtnCornerRadius
        deleteBtn.layer.cornerRadius = BigBtnCornerRadius
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
            self?.nameText.text = customer.full_name
            self?.numberText.text = customer.phone_number
            if let birthStr = customer.birthday, let birthDate = birthStr.toDate() {
                self?.datePicker.setDate(birthDate, animated: false)
                self?.viewModel.didSelectTimePicker = true
            }
        }
        
        viewModel.didDeleteOrder.addObserver(fireNow: false)  {[weak self] (isDone) in
            if isDone {
                self?.tryGetCustomerData()
            }
        }
    }
    
    override func removeBinding() {
        viewModel.customerOders.removeObserver()
    }
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        if Calendar.current.isDateInToday(sender.date) {
            self.viewModel.didSelectTimePicker = false
        } else {
            self.viewModel.didSelectTimePicker = true
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LashOrderViewController {
            let lashOrderVC = segue.destination as! LashOrderViewController
            lashOrderVC.setOrderInfoForDemo(data: self.viewModel.toDemoOrder ?? Order())
        }
        
        if segue.destination is KeratinOrderViewController {
            let keratinOrderVC = segue.destination as! KeratinOrderViewController
            keratinOrderVC.setOrderInfoForDemo(data: self.viewModel.toDemoOrder ?? Order())
        }
        
        if segue.destination is StoreRecordViewController {
            let storeRecordVC = segue.destination as! StoreRecordViewController
            storeRecordVC.setOrderInfo(data: self.viewModel.toDemoOrder ?? Order())
        }
    }
}


extension OrderRecordViewController: UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderListTableView.delegate = self
        self.orderListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let allTableCellCount = viewModel.customerOders.value.count
        return allTableCellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aCellHightOfViewRadio = 8
        let cellHight = orderListTableView.frame.height / CGFloat(aCellHightOfViewRadio)
        return cellHight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderListCell", for: indexPath)
        let foundOrders = viewModel.customerOders.value
        let index = indexPath.row
        let order = foundOrders[index]
        guard let createDate = order.created_at else {
            return cell
        }
        let nameText : UILabel = cell.contentView.viewWithTag(1) as! UILabel
        nameText.text = createDate.toYearMonthDayStr()
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTap)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().titleRed)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    @IBAction func handleDoubleTap(_ sender: Any){
        let foundOrders = viewModel.customerOders.value
        guard let index = self.orderListTableView.indexPathForSelectedRow else {
            return
        }
        let order = foundOrders[index.row]
        let isKeratin = order.service_content == "角蛋白"
        self.viewModel.toDemoOrder = order
        switch  self.viewModel.btnDestination {
        case .order, .none:
            if isKeratin {
                performSegue(withIdentifier: "toShowKeratinOrder", sender: self)
            } else {
                performSegue(withIdentifier: "toShowLashOrder", sender: self)
            }
        case .store:
            performSegue(withIdentifier: "toShowStoreDetail", sender: self)
        default:
            return
        }
    }
}
