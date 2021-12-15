//
//  KeratinOrderViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import UIKit

class KeratinOrderViewController: BaseViewController, UITextFieldDelegate{
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var datePickerBackground: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var typeForPicker: UITextField!
    @IBOutlet weak var softTime: UITextField!
    @IBOutlet weak var stableTime: UITextField!
    @IBOutlet weak var colorTime: UITextField!
    @IBOutlet weak var newOrderBtn: UIButton!
    
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    @IBAction func addNewAct(_ sender: Any) {
        guard let typeText = self.typeForPicker.text,
              let softTimeText = self.softTime.text,
              let stableTimeText = self.stableTime.text,
              let colorTimeText = self.colorTime.text
        else{
            return
        }
        if viewModel.demoOnly {
            prsentNormalAlert(msg: "修改訂單", btn: "確定", viewCTL: self, completion: {
        
                guard let prodId = self.controller.saveProductOrder(type: typeText, softTime: softTimeText, stableTime: stableTimeText, colorTime: colorTimeText) else {
                    return
                }
                var tmpOrder = self.viewModel.orderOfCustomer
                tmpOrder.created_date = self.datePicker.date
                tmpOrder.product_id = prodId
                self.controller.updateOrderToDb(order: tmpOrder)
            })
        } else {
            prsentNormalAlert(msg: "產生訂單", btn: "確定", viewCTL: self, completion: {
                guard let prodId = self.controller.saveProductOrder(type: typeText, softTime: softTimeText, stableTime: stableTimeText, colorTime: colorTimeText) else {
                    return
                }
                let doer = "WenJen"
                self.controller.saveOrderKeratin(prodId: prodId, doer: doer, note: self.noteText.text ?? "", setDate: self.datePicker.date, services: "角蛋白")
                self.performSegue(withIdentifier: "keratinToBillCheck", sender: self)
            })
        }
    }
    var controller: KeratinOrderController = KeratinOrderController()
    let typePicker: UIPickerView = UIPickerView()
    var viewModel: KeratinOrderModel {
        return controller.viewModel
    }
    
    public func setOrderInfo(cId: Int32) {
        self.controller.setOrderInfo(cId: cId)
    }
    
    public func setOrderInfoForDemo(data: Order) {
        self.controller.doDemoUpdate()
        self.controller.setOrderForDemo(data: data)
    }
    
    override func initBinding() {
        typeForPicker.delegate = self
        typeForPicker.inputView = typePicker
        
        viewModel.pickItemList.addObserver(fireNow: false) {[weak self] (newListData) in
            DispatchQueue.main.async {
                self?.typePicker.reloadAllComponents()
            }
        }
        
        typePicker.delegate = self
        typePicker.dataSource = self
    }
    
    override func initView() {
        titleView.roundedBottRight(radius: titleViewRadius)
        newOrderBtn.layer.cornerRadius = BigBtnCornerRadius
        noteText.layer.cornerRadius = textFieldCornerRadius
        typeForPicker.layer.cornerRadius = textFieldCornerRadius
        softTime.layer.cornerRadius = textFieldCornerRadius
        stableTime.layer.cornerRadius = textFieldCornerRadius
        colorTime.layer.cornerRadius = textFieldCornerRadius
        nameText.layer.cornerRadius = textFieldCornerRadius
        datePickerBackground.layer.cornerRadius = textFieldCornerRadius
        let name = controller.getCustomerName()
        nameText.text = name
        if self.viewModel.demoOnly {
            demoInit()
        }
    }
    override func removeBinding() {
        viewModel.pickItemList.removeObserver()
        typeForPicker.delegate = nil
        typePicker.delegate = nil
        typePicker.dataSource = nil
    }
    
    func demoInit() {
        let orderForDemo = self.viewModel.orderOfCustomer
        guard let prodType = self.controller.getProductData(id: orderForDemo.product_id)
        else {
            return
        }
        //customer
        self.controller.customerId = orderForDemo.user_id
        self.nameText.text = self.controller.getCustomerName()
        self.datePicker.date =  orderForDemo.created_date
        //order
        self.noteText.text = orderForDemo.note + "，金額：\(orderForDemo.total_price)"
        if prodType.name == EntityNameDefine.productKeratin {
            guard let keratinData = self.controller.getKeratinOrder(id: prodType.ref_id_1) else {
                return
            }
            self.typeForPicker.text = keratinData.type
            self.softTime.text = String(keratinData.soft_time)
            self.colorTime.text = String(keratinData.color_time)
            self.stableTime.text = String(keratinData.stable_time)
        }
        self.newOrderBtn.setTitle("更新", for: .normal)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if typeForPicker.isFirstResponder {
            controller.getTypeListFromDb()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillCheckViewController {
            let billVC = segue.destination as! BillCheckViewController
            billVC.setOrderData(detail: self.viewModel.orderOfCustomer)
        }
    }
}

extension KeratinOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let lashList = self.viewModel.pickItemList.value
        return lashList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lashList = self.viewModel.pickItemList.value
        let rowSelect = lashList[row]
         if typeForPicker.isFirstResponder {
            typeForPicker.text = rowSelect
            typeForPicker.endEditing(false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let lashList = self.viewModel.pickItemList.value
        let detailTitle = lashList[row]
        pickerLabel.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint, alpha: 1.0)
        pickerLabel.font = UIFont.systemFont(ofSize: 26)
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = detailTitle
        pickerView.backgroundColor = .white
        return pickerLabel
    }
}
