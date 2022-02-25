//
//  LashOderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class LashOrderController: BaseOrderController {
    let viewModel: LashOrderModel
    var lashType: [LashListType]? = []
    
    var tmpCompNum: Int?
    init(
        viewModel: LashOrderModel = LashOrderModel()
    ) {
        self.viewModel = viewModel
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
        self.viewModel.orderOfCustomer.user_id = cId
        self.setTopBottLashService(services: lashTypeList)
    }
    
    private func setTopBottLashService(services: [LashListType]) {
        for service in services {
            switch service {
            case .topLash, .addTopLash, .topAndBott, .removeRestart:
                self.viewModel.isLashTopEnable = true
            case .bottLash:
                self.viewModel.isLashBottEnable = true
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
        self.viewModel.orderOfCustomer.doer = doer
        self.viewModel.orderOfCustomer.note = note
    }
    
    public func getCustomerById(cId: Int32) -> Customer? {
        guard let customerInfo = entityGetter.getCustomer(id: cId) else {
            return nil
        }
        return customerInfo
    }
    
    public func getLashTypeFromDb(){
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["中間長", "眼尾長", "齊長", "多層次"]
    }
    
    public func getLashTopLenCurlFromDb() {
        // 6,7,8,9,10,11,12,13,14,15, 8-10,9-11,10-12,11-13
        // J/B/C/CC/D/U/L+
        self.viewModel.shouldShow2Component = true
        self.tmpCompNum = 2
        self.viewModel.pickItemList2 = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "8-10", "9-11", "10-12", "11-13"]
        self.viewModel.pickItemList.value = ["J", "B", "C", "CC", "D", "U", "L+"]
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
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["黑色", "棕色", "彩色"]
    }
    
    public func getLashTopSizeFromDb() {
        // 0.07 / 0.1
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["0.07", "0.08", "0.09", "0.1"]
    }
    
    public func getLashBottLenFromDb() {
        // 6,7,8
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["6", "7", "8"]
    }
    
    public func getLashBottCurlFromDb() {
        // J,B,C
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["J", "B", "C"]
    }
    
    public func getLashBottSizeFromDb() {
        // J,B,C
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["0.07", "0.01", "0.15", "0.1扁毛"]
    }
    
    public func getDoerFromDb() {
        self.viewModel.shouldShow2Component = false
        self.viewModel.pickItemList.value = ["Jen", "JaJen"]
    }
    
    public func setOderLash(prodId: Int64, doer: String, note: String, setDate: Date, services: String) {
        self.viewModel.orderOfCustomer.product_id = prodId
        self.viewModel.orderOfCustomer.doer = doer
        self.viewModel.orderOfCustomer.note = note
        self.viewModel.orderOfCustomer.created_date = setDate
        self.viewModel.orderOfCustomer.services = services
    }
    
    public func setLastEnable(isTopEnable: Bool, isBottEnable: Bool) {
        
    }
    
    public func toggleSeg() {
        self.viewModel.segmentToggleLeft.value = !self.viewModel.segmentToggleLeft.value
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
        self.viewModel.orderOfCustomer.id = data.id
        self.viewModel.orderOfCustomer.doer = data.doer ?? ""
        self.viewModel.orderOfCustomer.note = data.note ?? ""
        self.viewModel.orderOfCustomer.product_id = data.product_id
        self.viewModel.orderOfCustomer.store_money = data.store_money
        self.viewModel.orderOfCustomer.total_price = data.total_price
        self.viewModel.orderOfCustomer.income = data.income
        self.viewModel.orderOfCustomer.user_id = data.user_id
        self.viewModel.orderOfCustomer.services = data.service_content ?? ""
        self.viewModel.orderOfCustomer.created_date = data.created_at ?? Date()
        let serviceList = getLashList(servicesStr: self.viewModel.orderOfCustomer.services)
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
    
    public func doDemoUpdate() {
        self.viewModel.demoOnly = true
    }
}
