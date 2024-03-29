//
//  LashOrderViewController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import UIKit

class LashOrderViewController: BaseViewController, UITextFieldDelegate {
    var viewModel: LashOrderViewModel = LashOrderViewModel()
    let typePicker: UIPickerView = UIPickerView()
    
    var shouldShow2Component = false
    var demoOnly: Bool = false
    var switchStr: String = ""
    var leftLashData: LashPosType = LashPosType(text1: "", text2: "", text3: "", text4: "", text5: "")
    var rightLashData: LashPosType = LashPosType(text1: "", text2: "", text3: "", text4: "", text5: "")
    
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
    @IBAction func textPrimaryKeyTrigger(_ sender: Any) {
            view.endEditing(true)
    }
    
    @IBAction func addNewAct(_ sender: Any) {
        if self.demoOnly {
            prsentNormalAlert(msg: "修改訂單", btn: "確定", viewCTL: self, completion: {
                var tmpOrder = self.viewModel.orderOfCustomer
                tmpOrder.created_date = self.datePicker.date
                tmpOrder.doer = self.doerTextForPicker.text ?? tmpOrder.doer
//                tmpOrder.note = self.noteTextField.text ?? tmpOrder.note
                let getProdId = self.tryAddLashToDb() ?? tmpOrder.product_id
                tmpOrder.product_id = getProdId
                self.viewModel.updateOrderToDb(order: tmpOrder)
            })
        }else {
            self.addBorderToTop(color: .clear, isClear: true)
            self.addBorderToBott(color: .clear, isClear: true)
            prsentNormalAlert(msg: "產生訂單", btn: "確定", viewCTL: self, completion: {
                guard let doerText = self.doerTextForPicker.text,
                      let noteText = self.noteTextField.text
                else{
                    return
                }
                guard let prodId = self.tryAddLashToDb() else {
                    return
                }
                self.viewModel.setOderLash(prodId: prodId, doer: doerText, note: noteText, setDate: self.datePicker.date, services: self.lashTypeText.text)
                self.performSegue(withIdentifier: "lashToBillCheck", sender: self)
            })
        }
    }
    
    private func tryAddLashToDb() -> Int64? {
        self.storeLash5TextsToCache()
        if self.viewModel.isLashTopEnable {
            guard let topColor = self.colorTextForPicker.text,
                  let topSize = self.topSizeTextForPicker.text,
                  let topType = self.topTypeTextForPicker.text,
                  let topQuantityStr = self.numberOfToplashText.text
            else {
                return nil
            }
            if topColor == "" || topSize == "" || topType == "" || topQuantityStr == "" {
                self.addBorderToTop(color: UIColor.red, isClear: false)
                return nil
            }
            let left_1 = self.leftLashData.text1
            let left_2 = self.leftLashData.text2
            let left_3 = self.leftLashData.text3
            let left_4 = self.leftLashData.text4
            let left_5 = self.leftLashData.text5
            let right_1 = self.rightLashData.text1
            let right_2 = self.rightLashData.text2
            let right_3 = self.rightLashData.text3
            let right_4 = self.rightLashData.text4
            let right_5 = self.rightLashData.text5
            let topQuantityInt = Int16(topQuantityStr) ?? 0
            if self.viewModel.isLashBottEnable {
                guard let bottSize = self.bottSizeTextForPicker.text,
                      let bottLen = self.bottLenTextForPicker.text,
                      let bottCurl = self.bottCurTextForPicker.text,
                      let bottQuantityStr = self.numberOfBottlashText.text
                else {
                    return nil
                }
                if bottSize == "" || bottLen == "" || bottCurl == "" || bottQuantityStr == "" {
                    self.addBorderToBott(color: UIColor.red, isClear: false)
                    return nil
                }
                let bottQuantityInt = Int16(bottQuantityStr) ?? 0
                guard let prodId = self.viewModel.saveProductTopBott(top_color: topColor, top_size: topSize, top_type: topType, top_total_quantity: topQuantityInt, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5, bott_length: bottLen, bott_size: bottSize, bott_total_quantity: bottQuantityInt, bott_curl: bottCurl) else {
                    return nil
                }
                return prodId
            } else {
                guard let prodId = self.viewModel.saveProductTop(color: topColor, size: topSize, type: topType, total_quantity: topQuantityInt, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5) else {
                    return nil
                }
                return prodId
            }
        } else {
            if self.viewModel.isLashBottEnable {
                guard let bottSize = self.bottSizeTextForPicker.text,
                      let bottLen = self.bottLenTextForPicker.text,
                      let bottCurl = self.bottCurTextForPicker.text,
                      let bottQuantityStr = self.numberOfBottlashText.text
                else {
                    return nil
                }
                if bottSize == "" || bottLen == "" || bottCurl == "" || bottQuantityStr == "" {
                    self.addBorderToBott(color: UIColor.red, isClear: false)
                    return nil
                }
                let bottQuantityInt = Int16(bottQuantityStr) ?? 0
                guard let prodId = self.viewModel.saveProductBott(length: bottLen, size: bottSize, total_quantity: bottQuantityInt, curl: bottCurl) else {
                    return nil
                }
                return prodId
            } else {
                return nil
            }
        }
    }
    
    private func storeLash5TextsToCache() {
        if self.switchStr == "右" {
            self.rightLashData = LashPosType(text1: self.topLashText1.text!, text2: self.topLashText2.text!, text3: self.topLashText3.text!, text4: self.topLashText4.text!, text5: self.topLashText5.text!)
        } else {
            self.leftLashData = LashPosType(text1: self.topLashText1.text!, text2: self.topLashText2.text!, text3: self.topLashText3.text!, text4: self.topLashText4.text!, text5: self.topLashText5.text!)
        }
    }
    
    private func addBorderToTop(color: UIColor, isClear: Bool) {
        if isClear {
            self.topSizeTextForPicker.layer.borderWidth = 0
            self.topTypeTextForPicker.layer.borderWidth = 0
            self.colorTextForPicker.layer.borderWidth = 0
            self.numberOfToplashText.layer.borderWidth = 0
        } else {
                self.topSizeTextForPicker.layer.borderWidth = 1
                self.topTypeTextForPicker.layer.borderWidth = 1
                self.colorTextForPicker.layer.borderWidth = 1
                self.numberOfToplashText.layer.borderWidth = 1
        }
        self.topSizeTextForPicker.layer.borderColor = color.cgColor
        self.topTypeTextForPicker.layer.borderColor = color.cgColor
        self.colorTextForPicker.layer.borderColor = color.cgColor
        self.numberOfToplashText.layer.borderColor = color.cgColor
    }
    
    private func addBorderToBott(color: UIColor, isClear: Bool) {
        if isClear {
            self.bottCurTextForPicker.layer.borderWidth = 0
            self.bottLenTextForPicker.layer.borderWidth = 0
            self.bottSizeTextForPicker.layer.borderWidth = 0
            self.numberOfBottlashText.layer.borderWidth = 0
        } else {
                self.bottCurTextForPicker.layer.borderWidth = 1
                self.bottLenTextForPicker.layer.borderWidth = 1
                self.bottSizeTextForPicker.layer.borderWidth = 1
                self.numberOfBottlashText.layer.borderWidth = 1
        }
        self.bottCurTextForPicker.layer.borderColor = color.cgColor
        self.bottLenTextForPicker.layer.borderColor = color.cgColor
        self.bottSizeTextForPicker.layer.borderColor = color.cgColor
        self.numberOfBottlashText.layer.borderColor = color.cgColor
    }
    
    override func removeBinding() {
        typePicker.delegate = nil
        typePicker.dataSource = nil
        topTypeTextForPicker.delegate = nil
        topSizeTextForPicker.delegate = nil
        bottSizeTextForPicker.delegate = nil
        bottCurTextForPicker.delegate = nil
        bottLenTextForPicker.delegate = nil
        doerTextForPicker.delegate = nil
        colorTextForPicker.delegate = nil
        topLashText1.delegate = nil
        topLashText2.delegate = nil
        topLashText3.delegate = nil
        topLashText4.delegate = nil
        topLashText5.delegate = nil
        
    }
    
    override func initBinding() {
        super.initBinding()
        self.titleView.addGestureRecognizer(tapTitleView)
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
        viewModel.notEndEdingClosure = { textField in
            guard let textField = textField as? UITextField else{
                 return
            }
            textField.endEditing(false)
        }
        viewModel.pickItemListClosure = {[weak self] in
            let isSecondComponent = self!.shouldShow2Component
            DispatchQueue.main.async {
                self?.typePicker.reloadAllComponents()
                if !isSecondComponent {
                    self?.typePicker.selectRow(0, inComponent: 0, animated: false)
                }
            }
        }
        
        viewModel.segmentToggleLeftClosure = {[weak self] (isLeft) in
            var currentLashData: LashPosType
            var xOffset: CGFloat
            if isLeft {
                xOffset = self!.segmentBackground.frame.size.width / 2
                self!.switchStr = "右"
                self!.leftLashData = LashPosType(text1: self!.topLashText1.text!, text2: self!.topLashText2.text!, text3: self!.topLashText3.text!, text4: self!.topLashText4.text!, text5: self!.topLashText5.text!)
                currentLashData = self!.rightLashData
                
            } else {
                xOffset = 0
                self!.switchStr = "左"
                self!.rightLashData = LashPosType(text1: self!.topLashText1.text!, text2: self!.topLashText2.text!, text3: self!.topLashText3.text!, text4: self!.topLashText4.text!, text5: self!.topLashText5.text!)
                currentLashData = self!.leftLashData
            }
            self!.segmentSwitch.frame.origin.x = xOffset
            self!.segmentSwitch.text = self!.switchStr
            self!.topLashText1.text = currentLashData.text1
            self!.topLashText2.text = currentLashData.text2
            self!.topLashText3.text = currentLashData.text3
            self!.topLashText4.text = currentLashData.text4
            self!.topLashText5.text = currentLashData.text5
        }
    }
    
    private func setTopData(data: ProductLashTop) {
        colorTextForPicker.text = data.color
        numberOfToplashText.text = String(data.total_quantity)
        topTypeTextForPicker.text = data.type
        topSizeTextForPicker.text = data.top_size
        
        self.leftLashData = LashPosType(text1: data.left_1 ?? "", text2: data.left_2 ?? "", text3: data.left_3 ?? "", text4: data.left_4 ?? "", text5: data.left_5 ?? "")
        self.rightLashData = LashPosType(text1: data.right_1 ?? "", text2: data.right_2 ?? "", text3: data.right_3 ?? "", text4: data.right_4 ?? "", text5: data.right_5 ?? "")
        let currentLashData = self.leftLashData
        self.topLashText1.text = currentLashData.text1
        self.topLashText2.text = currentLashData.text2
        self.topLashText3.text = currentLashData.text3
        self.topLashText4.text = currentLashData.text4
        self.topLashText5.text = currentLashData.text5
    }
    
    private func setBottData(data: ProductLashBott) {
        numberOfBottlashText.text = String(data.total_quantity)
        bottCurTextForPicker.text = data.curl
        bottLenTextForPicker.text = data.length
        bottSizeTextForPicker.text = data.bott_size
    }
    
    @IBAction func tapSegment(_ sender: Any) {
        self.viewModel.toggleSeg()
    }
    
    @IBAction func tapViewForReturn(_ sender: Any) {
        if topLashText1.isFirstResponder ||
            topLashText2.isFirstResponder ||
            topLashText3.isFirstResponder ||
            topLashText4.isFirstResponder ||
            topLashText5.isFirstResponder
        {
            let col1Select = self.viewModel.pickItemList[typePicker.selectedRow(inComponent: 0)]
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
        } else if numberOfToplashText.isFirstResponder {
            numberOfToplashText.endEditing(true)
        } else if numberOfBottlashText.isFirstResponder {
            numberOfBottlashText.endEditing(true)
        } else if noteTextField.isFirstResponder {
            noteTextField.endEditing(true)
        }
        else {
            guard self.viewModel.pickItemList.count > 0 else {
                return
            }
            let rowSelect = self.viewModel.pickItemList[typePicker.selectedRow(inComponent: 0)]
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
        super.initView()
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
        let name = viewModel.getCustomerName()
        nameText.text = name
        nameText.isUserInteractionEnabled = false
        let lashTypeStr = viewModel.getLashType()
        lashTypeText.text = lashTypeStr
        self.segmentSwitch.frame.size.width = self.segmentBackground.frame.size.width / 2 + 1
        if self.demoOnly {
            demoInit()
        }
    }
    
    func demoInit() {
        let orderForDemo = self.viewModel.orderOfCustomer
        guard let prodType = self.viewModel.getProductData(id: orderForDemo.product_id)
        else {
            return
        }
        //
        let allServicesStr = orderForDemo.services
        let allServices = allServicesStr.components(separatedBy: LashListTypePrefix)
        let topLashSelected: Bool = allServices.contains(LashListType.topAndBott.rawValue) || allServices.contains(LashListType.topLash.rawValue) || allServices.contains(LashListType.addTopLash.rawValue)
        let bottLashSelected: Bool = allServices.contains(LashListType.bottLash.rawValue) || allServices.contains(LashListType.topAndBott.rawValue)
        self.viewModel.setLastEnable(isTopEnable: topLashSelected, isBottEnable: bottLashSelected)
        //customer
        self.viewModel.customerId = orderForDemo.user_id
        self.nameText.text = self.viewModel.getCustomerName()
        self.datePicker.date =  orderForDemo.created_date
        //order
        self.lashTypeText.text = allServicesStr
        self.doerTextForPicker.text = orderForDemo.doer
        var noteText = ""
        if orderForDemo.note == "" {
            noteText = "金額：\(orderForDemo.total_price)"
        } else {
            noteText = orderForDemo.note + "，金額：\(orderForDemo.total_price)"
        }
        self.noteTextField.text = noteText
        //product
        switch prodType.name {
        case EntityNameDefine.productLashTop + "_" + EntityNameDefine.productLashBott:
            if let topData = self.viewModel.getProductLashTop(id: prodType.ref_id_1) {
                self.setTopData(data: topData)
            }
            if let bottData = self.viewModel.getProductLashBott(id: prodType.ref_id_2) {
                self.setBottData(data: bottData)
            }
        case EntityNameDefine.productLashTop:
            if let topData = self.viewModel.getProductLashTop(id: prodType.ref_id_1) {
                self.setTopData(data: topData)
            }
        case EntityNameDefine.productLashBott:
            if let bottData = self.viewModel.getProductLashBott(id: prodType.ref_id_2) {
                self.setBottData(data: bottData)
            }
        default:
            print("Product type name incorrect")
        }
        //btn
        self.newOrderBtn.setTitle("更新", for: .normal)
    }
    
    public func setOrderInfo(lashTypeList: [LashListType], cId: Int32) {
        self.viewModel.setOrderInfo(lashTypeList: lashTypeList, cId: cId)
    }
    
    public func setOrderInfoForDemo(data: Order) {
        self.demoOnly = true
        self.viewModel.setOrderForDemo(data: data)
    }
    
    public func setLastEnable(isTopEnable: Bool, isBottEnable: Bool) {
        self.viewModel.setLastEnable(isTopEnable: isTopEnable, isBottEnable: isBottEnable)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if topTypeTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashTypeFromDb()
        } else if topSizeTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashTopSizeFromDb()
        } else if bottSizeTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashBottSizeFromDb()
        } else if bottCurTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashBottCurlFromDb()
        } else if bottLenTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashBottLenFromDb()
        } else if doerTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getDoerFromDb()
        } else if colorTextForPicker.isFirstResponder {
            shouldShow2Component = false
            viewModel.getLashColorTypeFromDb()
        }
        else if topLashText1.isFirstResponder
        {
            topLashText1.text = ""
            shouldShow2Component = true
            viewModel.getLashTopLenCurlFromDb()
        } else if topLashText2.isFirstResponder
        {
            shouldShow2Component = true
            topLashText2.text = ""
            viewModel.getLashTopLenCurlFromDb()
        }else if topLashText3.isFirstResponder
        {
            shouldShow2Component = true
            topLashText3.text = ""
            viewModel.getLashTopLenCurlFromDb()
        }else if topLashText4.isFirstResponder
        {
            shouldShow2Component = true
            topLashText4.text = ""
            viewModel.getLashTopLenCurlFromDb()
        }else if topLashText5.isFirstResponder
        {
            shouldShow2Component = true
            topLashText5.text = ""
            viewModel.getLashTopLenCurlFromDb()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is BillCheckViewController {
            let billVC = segue.destination as! BillCheckViewController
            billVC.setOrderData(detail: self.viewModel.orderOfCustomer)
        }
    }
}

extension LashOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let isShouldShow2Component = self.shouldShow2Component
        if isShouldShow2Component {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let lashList = self.viewModel.pickItemList
        let isShouldShow2Component = self.shouldShow2Component
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
            let lashList = self.viewModel.pickItemList
            setSingleColSelected(rowSelect: lashList[row])
        }
    }
    
    private func didSelectLashTopComp2(textField: UITextField, row: Int, component: Int) {
            let tmpStr = self.viewModel.getSelectStr(row: row, component: component, exitStr: textField.text!, target: textField)
            textField.text! = tmpStr
        }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        var lashList = self.viewModel.pickItemList
        if self.shouldShow2Component && component == 1{
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


