//
//  StoreRecordViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/9.
//

import Foundation
import UIKit
class StoreRecordViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var dateBackground: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var storeMoney: UITextField!
    @IBOutlet weak var payMethod: UITextField!
    var controller: StoreRecordController = StoreRecordController()
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        nameText.layer.cornerRadius = textFieldCornerRadius
        dateBackground.layer.cornerRadius = textFieldCornerRadius
        priceText.layer.cornerRadius = BigBtnCornerRadius
        storeMoney.layer.cornerRadius = BigBtnCornerRadius
        payMethod.layer.cornerRadius = BigBtnCornerRadius
        guard let orderData = self.controller.getOrderData(),
              let customerData = self.controller.getCustomerData(),
              let custDiscountRule = self.controller.getCustomDiscountRule(orderId: orderData.id),
              let ruleDetail = self.controller.getDiscountRule(ruleId: custDiscountRule.rule_id)
        else {
            return
        }
        
        self.nameText.text = customerData.full_name
        if let orderDate = orderData.created_at {
            self.datePicker.setDate(orderDate, animated: true)
        }
        self.storeMoney.text = String(ruleDetail.total)
        self.priceText.text = String(orderData.total_price)
        self.payMethod.text = orderData.pay_method
        
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
    }
    
    public func setOrderInfo(data: Order) {
        self.controller.setOrderInfo(data: data)
    }
}
