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
    @IBOutlet weak var dateTableView: UITableView!
    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var orderListTableView: UITableView!
    @IBAction func searchAct(_ sender: Any) {
        self.tryGetCustomerData()
    }
    
    @IBAction func deleteAct(_ sender: Any) {
    }
    var controller: OrderRecordController = OrderRecordController()
    var viewModel: OrderRecordModel {
        return controller.viewModel
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
            controller.tryGetDataFromDb(name: name, phone: phone, birthday: birth)
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
    }
    
    override func removeBinding() {
        viewModel.customerOders.removeObserver()
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
        let nameText : UITextField = cell.contentView.viewWithTag(1) as! UITextField
        nameText.text = createDate.toYearMonthDayStr()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
