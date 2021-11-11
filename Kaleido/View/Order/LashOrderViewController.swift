//
//  LashOrderViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import UIKit

class LashOrderViewController: BaseViewController, UITextFieldDelegate {
    var viewModel: LashOderModel {
        return controller.viewModel
    }
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var numberOfToplashText: UITextField!
    @IBOutlet weak var topTypeTextForPicker: UITextField!
    @IBOutlet weak var topSizeTextForPicker: UITextField!
    
    @IBOutlet weak var numberOfBottlashText: UITextField!
    @IBOutlet weak var bottSizeTextForPicker: UITextField!
    @IBOutlet weak var bottCurTextForPicker: UITextField!
    @IBOutlet weak var bottLenTextForPicker: UITextField!
    @IBOutlet weak var doerTextForPicker: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var newOrderBtn: UIButton!
    @IBOutlet weak var lashTypeText: UITextView!
    
    @IBOutlet weak var topLashText1: UITextField!
    @IBOutlet weak var topLashText2: UITextField!
    @IBOutlet weak var topLashText3: UITextField!
    @IBOutlet weak var topLashText4: UITextField!
    @IBOutlet weak var topLashText5: UITextField!
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    var controller: LashOderController = LashOderController()
    let typePicker: UIPickerView = UIPickerView()
    
    override func initBinding() {
        topTypeTextForPicker.delegate = self
        topSizeTextForPicker.delegate = self
        bottSizeTextForPicker.delegate = self
        bottCurTextForPicker.delegate = self
        bottLenTextForPicker.delegate = self
        doerTextForPicker.delegate = self
        topLashText1.delegate = self
        topLashText2.delegate = self
        topLashText3.delegate = self
        topLashText4.delegate = self
        topLashText5.delegate = self
        topTypeTextForPicker.inputView = typePicker
        topSizeTextForPicker.inputView = typePicker
        bottSizeTextForPicker.inputView = typePicker
        bottCurTextForPicker.inputView = typePicker
        bottLenTextForPicker.inputView = typePicker
        doerTextForPicker.inputView = typePicker
        topLashText1.inputView = typePicker
        topLashText2.inputView = typePicker
        topLashText3.inputView = typePicker
        topLashText4.inputView = typePicker
        topLashText5.inputView = typePicker
        
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
        let statusBarheight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        self.titleView.frame.size.height = self.titleView.frame.height + statusBarheight
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
        numberOfToplashText.layer.cornerRadius = textFieldCornerRadius
        topTypeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        topSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        numberOfBottlashText.layer.cornerRadius = textFieldCornerRadius
        bottSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottCurTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottLenTextForPicker.layer.cornerRadius = textFieldCornerRadius
        doerTextForPicker.layer.cornerRadius = textFieldCornerRadius
        noteTextField.layer.cornerRadius = textFieldCornerRadius
        topLashText1.layer.cornerRadius = textFieldCornerRadius
        topLashText2.layer.cornerRadius = textFieldCornerRadius
        topLashText3.layer.cornerRadius = textFieldCornerRadius
        topLashText4.layer.cornerRadius = textFieldCornerRadius
        topLashText5.layer.cornerRadius = textFieldCornerRadius
        
        //update by in
        let name = controller.getCustomerName()
        nameText.text = name
        let lashTypeStr = controller.getLashType()
        lashTypeText.text = lashTypeStr
        
    }
    
    public func setOrderInfo(lashTypeList: [LashListType], cId: Int32) {
        self.controller.setOrderInfo(lashTypeList: lashTypeList, cId: cId)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTypeTextForPicker.isFirstResponder {
            controller.getLashTypeFromDb()
        } else if topSizeTextForPicker.isFirstResponder {
            controller.getLashTopSizeFromDb()
        } else if bottSizeTextForPicker.isFirstResponder {
            controller.getLashBottSizeFromDb()
        } else if bottCurTextForPicker.isFirstResponder {
            controller.getLashBottCurlFromDb()
        } else if bottLenTextForPicker.isFirstResponder {
            controller.getLashBottLenFromDb()
        } else if doerTextForPicker.isFirstResponder {
            controller.getDoerFromDb()
        } else if topLashText1.isFirstResponder
        {
            topLashText1.text = ""
            controller.getLashTopLenCurlFromDb()
        } else if topLashText2.isFirstResponder
        {
            topLashText2.text = ""
            controller.getLashTopLenCurlFromDb()
        }else if topLashText3.isFirstResponder
        {
            topLashText3.text = ""
            controller.getLashTopLenCurlFromDb()
        }else if topLashText4.isFirstResponder
        {
            topLashText4.text = ""
            controller.getLashTopLenCurlFromDb()
        }else if topLashText5.isFirstResponder
        {
            topLashText5.text = ""
            controller.getLashTopLenCurlFromDb()
        }
    }
}

extension LashOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let isShouldShow2Component = self.viewModel.shouldShow2Component
        if isShouldShow2Component {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let lashList = self.viewModel.pickItemList.value
        let isShouldShow2Component = self.viewModel.shouldShow2Component
        if isShouldShow2Component &&  component == 1{
            let lashList2 = self.viewModel.pickItemList2
            return lashList2.count
        }
        return lashList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let lashList = self.viewModel.pickItemList.value
        if topTypeTextForPicker.isFirstResponder {
            topTypeTextForPicker.text = lashList[row]
            topTypeTextForPicker.endEditing(false)
        } else if topSizeTextForPicker.isFirstResponder {
            topSizeTextForPicker.text = lashList[row]
            topSizeTextForPicker.endEditing(false)
        } else if bottSizeTextForPicker.isFirstResponder {
            bottSizeTextForPicker.text = lashList[row]
            bottSizeTextForPicker.endEditing(false)
        } else if bottCurTextForPicker.isFirstResponder {
            bottCurTextForPicker.text = lashList[row]
            bottCurTextForPicker.endEditing(false)
        } else if bottLenTextForPicker.isFirstResponder {
            bottLenTextForPicker.text = lashList[row]
            bottLenTextForPicker.endEditing(false)
        } else if doerTextForPicker.isFirstResponder {
            doerTextForPicker.text = lashList[row]
            doerTextForPicker.endEditing(false)
        } else if topLashText1.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText1, row: row, component: component)
        } else if topLashText2.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText2, row: row, component: component)
        } else if topLashText3.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText3, row: row, component: component)
        } else if topLashText4.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText4, row: row, component: component)
        }else if topLashText5.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText5, row: row, component: component)
        }
    }
    
    private func didSelectLashTopComp2(textField: UITextField, row: Int, component: Int) {
        var tmpStr = ""
        if !self.controller.isSelectBoth(compNum: component) {
            self.controller.setDidSelectBoth(compNum: component)
            if component == 1 {
                let lashList2 = self.viewModel.pickItemList2
                tmpStr = lashList2[row]
                textField.text! = tmpStr
            } else {
                tmpStr = self.viewModel.pickItemList.value[row]
                textField.text! = tmpStr
            }
        } else {
            if component == 1 {
                let lashList2 = self.viewModel.pickItemList2
                tmpStr = lashList2[row]
                textField.text! += tmpStr
            } else {
                tmpStr = self.viewModel.pickItemList.value[row]
                textField.text! = tmpStr + textField.text!
            }
            textField.endEditing(false)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var lashList = self.viewModel.pickItemList.value
        if self.viewModel.shouldShow2Component && component == 1{
            lashList = self.viewModel.pickItemList2
        }
        let detailTitle = lashList[row]
        pickerLabel.backgroundColor = UIColor.fromHexColor(rgbValue: ColorDef().mainTint, alpha: 1.0)
        pickerLabel.font = UIFont.systemFont(ofSize: 26)
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = detailTitle
        pickerView.backgroundColor = .white
        return pickerLabel
    }
    
    
}


