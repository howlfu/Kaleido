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
    @IBOutlet weak var titleView: UIView!
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newOrderBtn: UIButton!
    @IBOutlet weak var slashTypeText: UITextView!
    
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    var controller: SlashOderController = SlashOderController()
    let typePicker: UIPickerView = UIPickerView()
    
    override func initBinding() {
        topTypeTextForPicker.delegate = self
        topSizeTextForPicker.delegate = self
        bottSizeTextForPicker.delegate = self
        bottCurTextForPicker.delegate = self
        bottLenTextForPicker.delegate = self
        doerTextForPicker.delegate = self
        topTypeTextForPicker.inputView = typePicker
        topSizeTextForPicker.inputView = typePicker
        bottSizeTextForPicker.inputView = typePicker
        bottCurTextForPicker.inputView = typePicker
        bottLenTextForPicker.inputView = typePicker
        doerTextForPicker.inputView = typePicker
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        viewModel.pickItemList.addObserver(fireNow: false) {[weak self] (newListData) in
            DispatchQueue.main.async {
                self?.typePicker.reloadAllComponents()
            }
        }
    }
    
    override func initView() {
        // setup scroll view -- start
        let titleViewH = self.titleView.frame.height
        self.titleView.roundedBottRight(radius: titleViewRadius)
        let contHight = newOrderBtn.frame.origin.y - titleViewH
        let scrollViewH = UIScreen.main.bounds.height - titleViewH - self.newOrderBtn.frame.height - 20
        self.scrollView.frame.size.height = scrollViewH
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: contHight)
        self.newOrderBtn.frame.origin.y = scrollViewH + titleViewH + 10
        // setup scroll view -- end
        
        newOrderBtn.layer.cornerRadius = BigBtnCornerRadius
        nameText.layer.cornerRadius = textFieldCornerRadius
        numberOfTopSlashText.layer.cornerRadius = textFieldCornerRadius
        topTypeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        topSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        numberOfBottSlashText.layer.cornerRadius = textFieldCornerRadius
        bottSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottCurTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottLenTextForPicker.layer.cornerRadius = textFieldCornerRadius
        doerTextForPicker.layer.cornerRadius = textFieldCornerRadius
        noteTextField.layer.cornerRadius = textFieldCornerRadius
        
        //update by in
        let name = controller.getCustomerName()
        nameText.text = name
        let slashTypeStr = controller.getSlashType()
        slashTypeText.text = slashTypeStr
        
    }
    
    public func setOrderInfo(slashTypeList: [SlashListType], cId: Int32) {
        self.controller.setOrderInfo(slashTypeList: slashTypeList, cId: cId)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTypeTextForPicker.isFirstResponder {
            controller.getSlashTypeFromDb()
        } else if topSizeTextForPicker.isFirstResponder {
            controller.getSlashTopSizeFromDb()
        } else if bottSizeTextForPicker.isFirstResponder {
            controller.getSlashBottSizeFromDb()
        } else if bottCurTextForPicker.isFirstResponder {
            controller.getSlashBottCurlFromDb()
        } else if bottLenTextForPicker.isFirstResponder {
            controller.getSlashBottLenFromDb()
        } else if doerTextForPicker.isFirstResponder {
            controller.getDoerFromDb()
        }
    }
}

extension SlashOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let slashList = self.viewModel.pickItemList.value
        return slashList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let slashList = self.viewModel.pickItemList.value
        if topTypeTextForPicker.isFirstResponder {
            topTypeTextForPicker.text = slashList[row]
            topTypeTextForPicker.endEditing(false)
        } else if topSizeTextForPicker.isFirstResponder {
            topSizeTextForPicker.text = slashList[row]
            topSizeTextForPicker.endEditing(false)
        } else if bottSizeTextForPicker.isFirstResponder {
            bottSizeTextForPicker.text = slashList[row]
            bottSizeTextForPicker.endEditing(false)
        } else if bottCurTextForPicker.isFirstResponder {
            bottCurTextForPicker.text = slashList[row]
            bottCurTextForPicker.endEditing(false)
        } else if bottLenTextForPicker.isFirstResponder {
            bottLenTextForPicker.text = slashList[row]
            bottLenTextForPicker.endEditing(false)
        } else if doerTextForPicker.isFirstResponder {
            doerTextForPicker.text = slashList[row]
            doerTextForPicker.endEditing(false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let slashList = self.viewModel.pickItemList.value
        let detailTitle = slashList[row]
        pickerLabel.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint, alpha: 1.0)
        pickerLabel.font = UIFont.systemFont(ofSize: 26)
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = detailTitle
        pickerView.backgroundColor = .white
        return pickerLabel
    }
    
    
}


