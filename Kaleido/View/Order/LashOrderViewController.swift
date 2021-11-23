//
//  LashOrderViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import UIKit

class LashOrderViewController: BaseViewController, UITextFieldDelegate {
    var viewModel: LashOrderModel {
        return controller.viewModel
    }
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var numberOfToplashText: UITextField!
    @IBOutlet weak var topTypeTextForPicker: UITextField!
    @IBOutlet weak var topSizeTextForPicker: UITextField!
    @IBOutlet weak var colorTextForPicker: UITextField!
    @IBOutlet weak var datePickerBackground: UIView!
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
    @IBOutlet weak var segmentSwitch: UILabel!
    @IBOutlet weak var segmentBackground: UIView!
    @IBAction func dateDidChange(_ sender: Any) {
        presentedViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addNewAct(_ sender: Any) {
        prsentNormalAlert(msg: "此訂單將會儲存", btn: "確定", viewCTL: self, completion: {
            guard let doerText = self.doerTextForPicker.text,
                  let noteText = self.noteTextField.text
            else{
                return
            }
            self.controller.setOderDoerAndNote(doer: doerText, note: noteText)
        })
    }
    var controller: LashOrderController = LashOrderController()
    let typePicker: UIPickerView = UIPickerView()
    
    override func initBinding() {
        topTypeTextForPicker.delegate = self
        topSizeTextForPicker.delegate = self
        bottSizeTextForPicker.delegate = self
        bottCurTextForPicker.delegate = self
        bottLenTextForPicker.delegate = self
        doerTextForPicker.delegate = self
        colorTextForPicker.delegate = self
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
        colorTextForPicker.inputView = typePicker
        topLashText1.inputView = typePicker
        topLashText2.inputView = typePicker
        topLashText3.inputView = typePicker
        topLashText4.inputView = typePicker
        topLashText5.inputView = typePicker
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        let tabBackgroundGesture = UITapGestureRecognizer(target: self, action: #selector (tapViewForReturn))
       tabBackgroundGesture.numberOfTapsRequired = 1
       self.view.addGestureRecognizer(tabBackgroundGesture)
        let tabSegmentView = UITapGestureRecognizer(target: self, action: #selector (tapSegment))
        tabSegmentView.numberOfTapsRequired = 1
       self.segmentBackground.addGestureRecognizer(tabSegmentView)
        viewModel.pickItemList.addObserver(fireNow: false) {[weak self] (newListData) in
            let isSecondComponent = self!.viewModel.shouldShow2Component
            DispatchQueue.main.async {
                self?.typePicker.reloadAllComponents()
                if !isSecondComponent {
                    self?.typePicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
        }
        
        viewModel.segmentToggleLeft.addObserver(fireNow: false) {[weak self] (isLeft) in
            var currentLashType: LashPosType
            var xOffset: CGFloat
            var switchStr: String
            if isLeft {
                xOffset = 0
                switchStr = "左"
                self!.viewModel.rightLashData = LashPosType(text1: self!.topLashText1.text!, text2: self!.topLashText2.text!, text3: self!.topLashText3.text!, text4: self!.topLashText4.text!, text5: self!.topLashText5.text!)
                currentLashType = self!.viewModel.leftLashData
                
            } else {
                xOffset = self!.segmentBackground.frame.size.width / 2
                switchStr = "右"
                self!.viewModel.leftLashData = LashPosType(text1: self!.topLashText1.text!, text2: self!.topLashText2.text!, text3: self!.topLashText3.text!, text4: self!.topLashText4.text!, text5: self!.topLashText5.text!)
                currentLashType = self!.viewModel.rightLashData
            }
            self!.segmentSwitch.frame.origin.x = xOffset
            self!.segmentSwitch.text = switchStr
            self!.topLashText1.text = currentLashType.text1
            self!.topLashText2.text = currentLashType.text2
            self!.topLashText3.text = currentLashType.text3
            self!.topLashText4.text = currentLashType.text4
            self!.topLashText5.text = currentLashType.text5
        }
    }
    
    @IBAction func tapSegment(_ sender: Any) {
        self.controller.toggleSeg()
    }
    
    @IBAction func tapViewForReturn(_ sender: Any) {
        if topLashText1.isFirstResponder ||
            topLashText2.isFirstResponder ||
            topLashText3.isFirstResponder ||
            topLashText4.isFirstResponder ||
            topLashText5.isFirstResponder
        {
            let col1Select = self.viewModel.pickItemList.value[typePicker.selectedRow(inComponent: 0)]
            let col2Select = self.viewModel.pickItemList2[typePicker.selectedRow(inComponent: 1)]
            if  topLashText1.isFirstResponder {
                topLashText1.text = col1Select + col2Select
                topLashText1.endEditing(true)
            } else if topLashText2.isFirstResponder {
                topLashText2.text = col1Select + col2Select
                topLashText2.endEditing(true)
            } else if topLashText3.isFirstResponder {
                topLashText3.text = col1Select + col2Select
                topLashText3.endEditing(true)
            } else if topLashText4.isFirstResponder {
                topLashText4.text = col1Select + col2Select
                topLashText4.endEditing(true)
            } else if topLashText5.isFirstResponder {
                topLashText5.text = col1Select + col2Select
                topLashText5.endEditing(true)
            }
        } else {
            guard self.viewModel.pickItemList.value.count > 0 else {
                return
            }
            let rowSelect = self.viewModel.pickItemList.value[typePicker.selectedRow(inComponent: 0)]
            setSingleColSelected(rowSelect: rowSelect)
        }
        
    }
    
    private func setSingleColSelected(rowSelect: String)
    {
        if topTypeTextForPicker.isFirstResponder {
            topTypeTextForPicker.text = rowSelect
            topTypeTextForPicker.endEditing(false)
        } else if topSizeTextForPicker.isFirstResponder {
            topSizeTextForPicker.text = rowSelect
            topSizeTextForPicker.endEditing(false)
        } else if bottSizeTextForPicker.isFirstResponder {
            bottSizeTextForPicker.text = rowSelect
            bottSizeTextForPicker.endEditing(false)
        } else if bottCurTextForPicker.isFirstResponder {
            bottCurTextForPicker.text = rowSelect
            bottCurTextForPicker.endEditing(false)
        } else if bottLenTextForPicker.isFirstResponder {
            bottLenTextForPicker.text = rowSelect
            bottLenTextForPicker.endEditing(false)
        } else if doerTextForPicker.isFirstResponder {
            doerTextForPicker.text = rowSelect
            doerTextForPicker.endEditing(false)
        } else if colorTextForPicker.isFirstResponder {
            colorTextForPicker.text = rowSelect
            colorTextForPicker.endEditing(false)
        }
    }
    override func initView() {
        // setup scroll view -- start
        let statusBarheight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        self.titleView.frame.size.height = self.titleView.frame.height + statusBarheight
        let titleViewH = self.titleView.frame.height
        let contHight = newOrderBtn.frame.origin.y - titleViewH
        let scrollViewH = UIScreen.main.bounds.height - titleViewH - self.newOrderBtn.frame.height - 20
        self.scrollView.frame.size.height = scrollViewH
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: contHight)
        self.newOrderBtn.frame.origin.y = scrollViewH + titleViewH + 10
        // setup scroll view -- end
        titleView.roundedBottRight(radius: titleViewRadius)
        newOrderBtn.layer.cornerRadius = BigBtnCornerRadius
        nameText.layer.cornerRadius = textFieldCornerRadius
        datePickerBackground.layer.cornerRadius = textFieldCornerRadius
        lashTypeText.layer.cornerRadius = textFieldCornerRadius
        numberOfToplashText.layer.cornerRadius = textFieldCornerRadius
        topTypeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        topSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        numberOfBottlashText.layer.cornerRadius = textFieldCornerRadius
        bottSizeTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottCurTextForPicker.layer.cornerRadius = textFieldCornerRadius
        bottLenTextForPicker.layer.cornerRadius = textFieldCornerRadius
        doerTextForPicker.layer.cornerRadius = textFieldCornerRadius
        colorTextForPicker.layer.cornerRadius = textFieldCornerRadius
        noteTextField.layer.cornerRadius = textFieldCornerRadius
        topLashText1.layer.cornerRadius = textFieldCornerRadius
        topLashText2.layer.cornerRadius = textFieldCornerRadius
        topLashText3.layer.cornerRadius = textFieldCornerRadius
        topLashText4.layer.cornerRadius = textFieldCornerRadius
        topLashText5.layer.cornerRadius = textFieldCornerRadius
        segmentBackground.layer.cornerRadius = textFieldCornerRadius
        segmentBackground.clipsToBounds = true
        //update by in
        let name = controller.getCustomerName()
        nameText.text = name
        let lashTypeStr = controller.getLashType()
        lashTypeText.text = lashTypeStr
        self.segmentSwitch.frame.size.width = self.segmentBackground.frame.size.width / 2 + 1
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
        } else if colorTextForPicker.isFirstResponder {
            controller.getLashColorTypeFromDb()
        }
        else if topLashText1.isFirstResponder
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
        if topLashText1.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText1, row: row, component: component)
        } else if topLashText2.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText2, row: row, component: component)
        } else if topLashText3.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText3, row: row, component: component)
        } else if topLashText4.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText4, row: row, component: component)
        }else if topLashText5.isFirstResponder {
            didSelectLashTopComp2(textField: topLashText5, row: row, component: component)
        } else {
            let lashList = self.viewModel.pickItemList.value
            setSingleColSelected(rowSelect: lashList[row])
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


