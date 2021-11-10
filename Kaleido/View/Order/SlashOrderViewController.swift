//
//  SlashOrderViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import UIKit

class SlashOrderViewController: BaseViewController, UITextFieldDelegate {
    var viewModel: SlashOderModel {
        return controller.viewModel
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var numberOfTopSlashText: UITextField!
    @IBOutlet weak var topTypeTextForPicker: UITextField!
    @IBOutlet weak var topSizeTextForPicker: UITextField!
    
    @IBOutlet weak var numberOfBottSlashText: UITextField!
    @IBOutlet weak var bottSizeTextForPicker: UITextField!
    @IBOutlet weak var bottCurTextForPicker: UITextField!
    @IBOutlet weak var bottLenTextForPicker: UITextField!
    @IBOutlet weak var doerTextForPicker: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    var controller: SlashOderController = SlashOderController()
    let typePicker: UIPickerView = UIPickerView()
    
    override func initBinding() {
        topTypeTextForPicker.delegate = self
        topSizeTextForPicker.delegate = self
        topTypeTextForPicker.inputView = typePicker
        topSizeTextForPicker.inputView = typePicker
        typePicker.delegate = self
        typePicker.dataSource = self
    }
    
    public func setOrderInfo(slashTypeList: [SlashListType], cId: Int32) {
        self.controller.setOrderInfo(slashTypeList: slashTypeList, cId: cId)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTypeTextForPicker.isFirstResponder {
            controller.getSlashTypeFromDb()
        } else if topSizeTextForPicker.isFirstResponder {
            controller.getSlashTopSizeFromDb()
        }
        typePicker.reloadAllComponents()
    }
}

extension SlashOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let slashList = self.viewModel.pickItemList else {
            return 0
        }
        return slashList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let slashList = self.viewModel.pickItemList else {
            return
        }
        if topTypeTextForPicker.isFirstResponder {
            topTypeTextForPicker.text = slashList[row]
            topTypeTextForPicker.endEditing(false)
        } else if topSizeTextForPicker.isFirstResponder {
            topSizeTextForPicker.text = slashList[row]
            topSizeTextForPicker.endEditing(false)
        }
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        if let slashList = self.viewModel.pickItemList {
            let detailTitle = slashList[row]
            pickerLabel.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint, alpha: 1.0)
            pickerLabel.font = UIFont.systemFont(ofSize: 26)
            pickerLabel.textAlignment = NSTextAlignment.center
            pickerLabel.text = detailTitle
        }
        pickerView.backgroundColor = .white
        return pickerLabel
    }
    
    
}


