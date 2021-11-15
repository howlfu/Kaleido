//
//  LashOderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class LashOrderController {
    let viewModel: LashOrderModel
    var lashType: [LashListType]? = []
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    var customerId: Int32? = 0
    var tmpCompNum: Int?
    init(
        viewModel: LashOrderModel = LashOrderModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func getCustomerName() -> String{
        guard
            let cId = customerId,
            let customer = entityGetter.getCustomer(id: cId),
            let name = customer.full_name
        else { return "" }
        return name
    }
    
    public func getLashType() -> String {
        var retStr = ""
        guard let lashTypeList = lashType else {
            return retStr
        }
        var prefix = ""
        for type in lashTypeList  {
            retStr += prefix + type.rawValue
            prefix = ", "
        }
        return retStr
    }
    
    public func setOrderInfo(lashTypeList: [LashListType], cId: Int32) {
        self.lashType = lashTypeList
        self.customerId = cId
        self.viewModel.orderOfCustomer.user_id = cId
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
    
    func setOderToDb(uId: Int32, prodId: Int16, storeMoney: Int16, totalPrice: Int16, remainMoney: Int16, doer: String, note:String) {
     
        if entitySetter.createOrder(uId: uId, prodId: prodId, storeMoney: storeMoney, totalPrice: totalPrice, remainMoney: remainMoney, doer: doer, note: note) {
            //renew
            
        } else {
            
        }
    }
    
    public func addLashType() {
        
    }
}
