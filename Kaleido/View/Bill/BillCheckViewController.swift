//
//  BillCheckViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
import UIKit
class BillCheckViewController: BaseViewController {
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var remainText: UITextField!
    @IBOutlet weak var savedText: UITextField!
    @IBOutlet weak var needPayMoney: UITextField!
    @IBOutlet weak var totalRemainText: UITextField!
    @IBOutlet weak var payMethodTableView: UITableView!
    @IBOutlet weak var signViewLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    @IBAction func saveBtnAct(_ sender: Any) {

        let price = controller.getCalcResult(price: self.priceText.text!, shouldSave: true)
        let profit = controller.getProfit()
        prsentNormalAlert(msg: "本次收益：\(profit)", btn: "確定", viewCTL: self, completion: {
            guard var savedOrderTmp = self.viewModel.orderOfCustomer else {
                print("Temporary order data not exist")
                return
            }
            //save customer.remain_money
            let remainStoredMoney = self.controller.getCurrentRemainMoney()
            self.controller.saveRemainMoneyToCustomer(remain: remainStoredMoney)
            
            savedOrderTmp.income = profit
            savedOrderTmp.pay_method = self.controller.getPayMethodName()
            savedOrderTmp.store_money = remainStoredMoney
            savedOrderTmp.total_price = Int16(self.priceText.text!) ?? 0
            let orderId = self.controller.setOrderToDb(detail: savedOrderTmp)
            if let custDiscount = self.viewModel.customerDiscountId {
                self.controller.updateCustomerDiscount(id: custDiscount, orderId: orderId)
            }
            self.navigationController?.popToRootViewController(animated: false)
        })
    }
    @IBAction func checkBtnAct(_ sender: Any) {
        self.priceText.layer.borderWidth = 0
        guard let priceText = self.priceText.text, priceText != "" else {
            self.priceText.layer.borderWidth = 1.0
            self.priceText.layer.borderColor = UIColor.red.cgColor
            return
        }
        let needPay = controller.getCalcResult(price: priceText, shouldSave: false)
        let remainStoredMoney = controller.getCurrentRemainMoney(price: priceText)
        needPayMoney.text = String(needPay)
        totalRemainText.text = String(remainStoredMoney)
        saveBtn.isHidden = false
    }
    
    var controller: BillCheckController = BillCheckController()
    var viewModel: BillCheckModel {
        return controller.viewModel
    }
    let aCellHightOfViewRadio = 2
    let typePicker: UIPickerView = UIPickerView()
    override func removeBinding() {
        typePicker.delegate = nil
        typePicker.dataSource = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("")
    }
    override func initView() {
        super.initView()
        titleView.roundedBottRight(radius: titleViewRadius)
        priceText.layer.cornerRadius = textFieldCornerRadius
        remainText.layer.cornerRadius = textFieldCornerRadius
        savedText.layer.cornerRadius = textFieldCornerRadius
        totalRemainText.layer.cornerRadius = textFieldCornerRadius
        checkBtn.layer.cornerRadius = BigBtnCornerRadius
        saveBtn.layer.cornerRadius = BigBtnCornerRadius
        saveBtn.isHidden = true
        guard let orderTmp = self.viewModel.orderOfCustomer,
              let customerDetail = self.controller.getCustomer(id: orderTmp.user_id)
        else {return}
        let customerMoney = customerDetail.remain_money
        remainText.text = String(customerMoney)
    }
    
    override func initBinding() {
        savedText.inputView = self.typePicker
        typePicker.delegate = self
        typePicker.dataSource = self
        let tabBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector (tapViewForReturn))
        tabBackgroundGesture.numberOfTapsRequired = 1
        tabBackgroundGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tabBackgroundGesture)
    }
    
    @IBAction func tapViewForReturn(_ sender: Any) {
        if savedText.isFirstResponder {
            self.viewModel.selectedDiscountRuleId = nil
            self.savedText.text = ""
            self.savedText.endEditing(true)
        }
    }
    
    public func setOrderData(detail: OrderEntityType) {
        controller.setOrderDetail(detail: detail)
    }
    
}

extension BillCheckViewController: UITableViewDataSource, UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.payMethodTableView.delegate = self
        self.payMethodTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let methodArr = self.viewModel.payMethodArr else {
            return 0
        }
        return methodArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payMethodCell", for: indexPath)
        let statusIcon : UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let lblTitle : UILabel = cell.contentView.viewWithTag(2) as! UILabel
        let statusBG : UIImageView = cell.contentView.viewWithTag(3) as! UIImageView
        let backgroundView : UIView = cell.contentView.viewWithTag(4)!
        guard let methodArr = self.viewModel.payMethodArr else {
            return cell
        }
        statusIcon.frame.origin.y = (backgroundView.frame.height - statusIcon.frame.size.height) / 2
        statusBG.frame.origin.y = (backgroundView.frame.height - statusBG.frame.size.height) / 2
        lblTitle.frame.origin.y = (backgroundView.frame.height - lblTitle.frame.size.height) / 2
        let textIndex = methodArr.index(methodArr.startIndex, offsetBy: indexPath.row)
        lblTitle.text = methodArr.map{$0.key}[textIndex]
        cell.contentView.frame.size.width = (cell.contentView.frame.size.width * 2) / 3
        cell.contentView.frame.size.height = (cell.contentView.frame.size.height * 2) / 3
        backgroundView.layer.cornerRadius = BigBtnCornerRadius
        backgroundView.sendSubviewToBack(cell)
        return cell
    }
    
    //UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return payMethodTableView.frame.height / CGFloat(aCellHightOfViewRadio)
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        cellSelected(cell: selectedCell, currentIndex: indexPath)
    }
    
    func cellSelected(cell: UITableViewCell?, currentIndex: IndexPath) {
        guard let selectedCell = cell else {
            return
        }
        let statusIcon : UIImageView = selectedCell.contentView.viewWithTag(1) as! UIImageView
        guard let lastInex = self.viewModel.lastSelectionInex else {
            self.viewModel.lastSelectionInex = currentIndex
            statusIcon.image = UIImage(named: "Checked")
            return
        }
        
        if lastInex == currentIndex {
            // clear the same selected
            statusIcon.image =  nil
            self.viewModel.lastSelectionInex = nil
        } else {
            statusIcon.image = UIImage(named: "Checked")
            // clear selected before
            guard let lastCell = self.payMethodTableView.cellForRow(at: lastInex) else {
                return
            }
            let lastStatusIcon : UIImageView = lastCell.contentView.viewWithTag(1) as! UIImageView
            lastStatusIcon.image = nil
            self.viewModel.lastSelectionInex = currentIndex
        }
       
    }
}

extension BillCheckViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let discountRules = self.viewModel.discountRule else {
            return 0
        }
        return discountRules.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let discountRules = self.viewModel.discountRule else {
            return
        }
        let ruleSelected = discountRules[row]
        self.savedText.text = String(ruleSelected.total)
        self.viewModel.selectedDiscountRuleId = ruleSelected.id
        self.savedText.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        guard let discountRules = self.viewModel.discountRule else {
            return pickerLabel
        }
        let detailTitle = String(discountRules[row].total)
        pickerLabel.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint, alpha: 1.0)
        pickerLabel.font = UIFont.systemFont(ofSize: 26)
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = detailTitle
        pickerView.backgroundColor = .white
        return pickerLabel
    }
    
    
}
