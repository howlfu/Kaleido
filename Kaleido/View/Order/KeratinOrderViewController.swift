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
    
    @IBOutlet weak var datePicker: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var colorForPicker: UITextField!
    @IBOutlet weak var typeForPicker: UITextField!
    @IBOutlet weak var softTime: UITextField!
    @IBOutlet weak var fixTime: UITextField!
    @IBOutlet weak var colorTime: UITextField!
    @IBOutlet weak var newOrderBtn: UIButton!
    
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    var controller: KeratinOrderController = KeratinOrderController()
    let typePicker: UIPickerView = UIPickerView()
    var viewModel: KeratinOrderModel {
        return controller.viewModel
    }
    override func initBinding() {
        colorForPicker.delegate = self
        colorForPicker.inputView = typePicker
        viewModel.pickItemList.addObserver(fireNow: false) {[weak self] (newListData) in
            DispatchQueue.main.async {
                self?.typePicker.reloadAllComponents()
            }
        }
        colorForPicker.delegate = self
        typePicker.delegate = self
        typePicker.dataSource = self
    }
    
    override func initView() {
        titleView.roundedBottRight(radius: titleViewRadius)
        newOrderBtn.layer.cornerRadius = BigBtnCornerRadius
        noteText.layer.cornerRadius = textFieldCornerRadius
        colorForPicker.layer.cornerRadius = textFieldCornerRadius
        typeForPicker.layer.cornerRadius = textFieldCornerRadius
        softTime.layer.cornerRadius = textFieldCornerRadius
        fixTime.layer.cornerRadius = textFieldCornerRadius
        colorTime.layer.cornerRadius = textFieldCornerRadius
        nameText.layer.cornerRadius = textFieldCornerRadius
        datePickerBackground.layer.cornerRadius = textFieldCornerRadius
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if colorForPicker.isFirstResponder {
            controller.getTypeListFromDb()
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
    
    
}
