//
//  LashOderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class LashOderController {
    let viewModel: LashOderModel
    var lashType: [LashListType]? = []
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    var customerId: Int32? = 0
    init(
        viewModel: LashOderModel = LashOderModel()
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
    }
    
    public func getCustomerById(cId: Int32) -> Customer? {
        guard let customerInfo = entityGetter.getCustomer(id: cId) else {
            return nil
        }
        return customerInfo
    }
    
    public func getLashTypeFromDb(){
        self.viewModel.pickItemList.value = ["中間長", "眼尾長", "齊長"]
    }
    
    public func getLashTopLenFromDb() {
        // 6,7,8,9,10,11,12,13,14,15, 8-10,9-11,10-12,11-13
        self.viewModel.pickItemList.value = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "8-10", "9-11", "10-12", "11-13"]
    }
    
    public func getLashTopCurlFromDb() {
        // J/B/C/CC/D/U/L+
        self.viewModel.pickItemList.value = ["J", "B", "C", "CC", "D", "U", "L+"]
    }
    
    public func getLashTopSizeFromDb() {
        // 0.07 / 0.1
        self.viewModel.pickItemList.value = ["0.07", "0.08", "0.09", "0.1"]
    }
    
    public func getLashBottLenFromDb() {
        // 6,7,8
        self.viewModel.pickItemList.value = ["6", "7", "8"]
    }
    
    public func getLashBottCurlFromDb() {
        // J,B,C
        self.viewModel.pickItemList.value = ["J", "B", "C"]
    }
    
    public func getLashBottSizeFromDb() {
        // J,B,C
        self.viewModel.pickItemList.value = ["0.07", "0.01", "0.15", "0.1扁毛"]
    }
    
    public func getDoerFromDb() {
        self.viewModel.pickItemList.value = ["Jen", "JaJen"]
    }
    
    public func setOderToDb() {
        
    }
    
    public func addLashType() {
        
    }
}
