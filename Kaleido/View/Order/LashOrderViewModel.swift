//
//  LashOderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class LashOrderViewModel: BaseOrderController {
    
    var pickItemList2: [String] = []
    var orderOfCustomer = OrderEntityType(id: 0, doer: "", note: "", pay_method: "", product_id: 0, store_money: 0, total_price: 0, income: 0, user_id: 0, created_date: Date(), services: "")
    var isLashTopEnable:Bool = false
    var isLashBottEnable:Bool = false

    var lashType: [LashListType]? = []
    var tmpCompNum: Int?
    
    var pickItemListClosure: (() -> ())?
    var segmentToggleLeftClosure: ((Bool) -> ())?
    var notEndEdingClosure: ((Any) -> ())?
    
    var pickItemList: [String] = [] {
        didSet{
            pickItemListClosure?()
        }
    }
    
    var segmentToggleLeft: Bool = false {
        didSet{
            segmentToggleLeftClosure?(segmentToggleLeft)
        }
    }
    public func getLashType() -> String {
        var retStr = ""
        guard let lashTypeList = lashType else {
            return retStr
        }
        var prefix = ""
        for type in lashTypeList  {
            retStr += prefix + type.rawValue
            prefix = LashListTypePrefix
        }
        return retStr
    }
    
    public func setOrderInfo(lashTypeList: [LashListType], cId: Int32) {
        self.lashType = lashTypeList
        self.customerId = cId
        self.orderOfCustomer.user_id = cId
        self.setTopBottLashService(services: lashTypeList)
    }
    
    private func setTopBottLashService(services: [LashListType]) {
        for service in services {
            switch service {
            case .topLash, .addTopLash, .topAndBott, .removeRestart:
                self.isLashTopEnable = true
            case .bottLash:
                self.isLashBottEnable = true
            default:
                print("other service only")
//            case .removeOnly:
//                <#code#>
//            case .lashSpa:
//                <#code#>
//            case .lashSuite:
//                <#code#>
//            case .lashLiquid:
//                <#code#>
            }
        }
    }
    
    public func setOderDoerAndNote(doer: String, note: String) {
        self.orderOfCustomer.doer = doer
        self.orderOfCustomer.note = note
    }
    
    public func getCustomerById(cId: Int32) -> Customer? {
        guard let customerInfo = entityGetter.getCustomer(id: cId) else {
            return nil
        }
        return customerInfo
    }
    
    public func getLashTypeFromDb(){
        self.pickItemList = ["中間長", "眼尾長", "齊長", "多層次"]
    }
    
    public func getLashTopLenCurlFromDb() {
        // 6,7,8,9,10,11,12,13,14,15, 8-10,9-11,10-12,11-13
        // J/B/C/CC/D/U/L+
        self.tmpCompNum = 2 //default 2
        self.pickItemList2 = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "8-10", "9-11", "10-12", "11-13"]
        self.pickItemList = ["J", "B", "C", "CC", "D", "U", "L+"]
    }
    
    public func setDidSelectBoth(compNum: Int) {
        self.tmpCompNum = compNum
    }
    
    public func isSelectBoth(compNum: Int) -> Bool{
        if self.tmpCompNum != 2 && self.tmpCompNum != compNum{
            return true
        }
        return false
    }
    public func getLashColorTypeFromDb() {
        self.pickItemList = ["黑色", "棕色", "彩色"]
    }
    
    public func getLashTopSizeFromDb() {
        // 0.07 / 0.1
        self.pickItemList = ["0.07", "0.08", "0.09", "0.1"]
    }
    
    public func getLashBottLenFromDb() {
        // 6,7,8
        self.pickItemList = ["6", "7", "8"]
    }
    
    public func getLashBottCurlFromDb() {
        // J,B,C
        self.pickItemList = ["J", "B", "C"]
    }
    
    public func getLashBottSizeFromDb() {
        // J,B,C
        self.pickItemList = ["0.07", "0.01", "0.15", "0.1扁毛"]
    }
    
    public func getDoerFromDb() {
        self.pickItemList = ["Jen", "JaJen"]
    }
    
    public func setOderLash(prodId: Int64, doer: String, note: String, setDate: Date, services: String) {
        self.orderOfCustomer.product_id = prodId
        self.orderOfCustomer.doer = doer
        self.orderOfCustomer.note = note
        self.orderOfCustomer.created_date = setDate
        self.orderOfCustomer.services = services
    }
    
    public func setLastEnable(isTopEnable: Bool, isBottEnable: Bool) {
        
    }
    
    public func toggleSeg() {
        self.segmentToggleLeft = !self.segmentToggleLeft
    }
    
    public func saveProductTopBott(top_color: String, top_size: String, top_type: String, top_total_quantity: Int16, left_1: String, left_2: String, left_3: String, left_4: String, left_5: String, right_1: String, right_2: String, right_3: String, right_4: String, right_5: String, bott_length: String, bott_size: String, bott_total_quantity: Int16, bott_curl: String) -> Int64? {
        
        let prodId = entitySetter.createProductLashTopBott(top_color: top_color, top_size: top_size, top_type: top_type, top_total_quantity: top_total_quantity, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5, bott_length: bott_length, bott_size: bott_size, bott_total_quantity: bott_total_quantity, bott_curl: bott_curl)
        return prodId
    }
    
    public func saveProductTop(color: String, size: String, type: String, total_quantity: Int16, left_1: String, left_2: String, left_3: String, left_4: String, left_5: String, right_1: String, right_2: String, right_3: String, right_4: String, right_5: String)  -> Int64? {
        let prodId = entitySetter.createProductLashTop(color: color, size: size, type: type, total_quantity: total_quantity, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5)
        return prodId
    }
    
    public func saveProductBott(length: String, size: String, total_quantity: Int16, curl: String)   -> Int64? {
        let prodId = entitySetter.createProductLashBott(length: length, size: size, total_quantity: total_quantity, curl: curl)
        return prodId
    }
    
    
    public func getProductLashTop(id: Int32) -> ProductLashTop? {
        return entityGetter.getProductTopLash(id: id)
    }
    
    public func getProductLashBott(id: Int32) -> ProductLashBott? {
        return entityGetter.getProductBottLash(id: id)
    }
    
    public func setOrderForDemo(data: Order) {
        self.orderOfCustomer.id = data.id
        self.orderOfCustomer.doer = data.doer ?? ""
        self.orderOfCustomer.note = data.note ?? ""
        self.orderOfCustomer.product_id = data.product_id
        self.orderOfCustomer.store_money = data.store_money
        self.orderOfCustomer.total_price = data.total_price
        self.orderOfCustomer.income = data.income
        self.orderOfCustomer.user_id = data.user_id
        self.orderOfCustomer.services = data.service_content ?? ""
        self.orderOfCustomer.created_date = data.created_at ?? Date()
        //set top or bott flag
        let serviceList = getLashList(servicesStr: self.orderOfCustomer.services)
        self.setTopBottLashService(services: serviceList)
    }
    
    private func getLashList(servicesStr: String) -> [LashListType] {
        var retList: [LashListType] = []
        let serviceArr = servicesStr.components(separatedBy: LashListTypePrefix)
        for service in serviceArr  {
            if let serType: LashListType = self.getTypeFrom(strName: String(service)) {
                retList.append(serType)
            }
        }
        return retList
    }
    
    func getTypeFrom(strName: String) -> LashListType?{
        switch strName {
        case LashListType.topLash.rawValue:
            return .topLash
        case LashListType.bottLash.rawValue:
            return .bottLash
        case LashListType.addTopLash.rawValue:
            return .addTopLash
        case LashListType.topAndBott.rawValue:
            return .topAndBott
        case LashListType.removeRestart.rawValue:
            return .removeRestart
        case LashListType.removeOnly.rawValue:
            return .removeOnly
        case LashListType.lashSpa.rawValue:
            return .lashSpa
        case LashListType.lashSuite.rawValue:
            return .lashSuite
        case LashListType.lashLiquid.rawValue:
            return .lashLiquid
        default:
            return nil
        }
    }
    
    public func addLashType() {
        
    }
    
    public func getSelectStr(row: Int, component: Int, exitStr: String, target: Any) -> String{
        var tmpStr: String = ""
        if !self.isSelectBoth(compNum: component) {
            self.setDidSelectBoth(compNum: component)
            if component == 1 {
                let lashList2 = self.pickItemList2
                tmpStr = lashList2[row]
            } else {
                tmpStr = self.pickItemList[row]
            }
        } else {
            if component == 1 {
                let lashList2 = self.pickItemList2
                tmpStr = lashList2[row]
                tmpStr = exitStr + tmpStr
            } else {
                tmpStr = self.pickItemList[row]
                tmpStr = tmpStr + exitStr
            }
            self.notEndEdingClosure!(target)
        }
        return tmpStr
    }
}
