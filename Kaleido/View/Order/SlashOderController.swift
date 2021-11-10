//
//  SlashOderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class SlashOderController {
    let viewModel: SlashOderModel
    var slashType: [SlashListType]? = []
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    var customerId: Int32? = 0
    init(
        viewModel: SlashOderModel = SlashOderModel()
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
    
    public func getSlashType() -> String {
        var retStr = ""
        guard let slashTypeList = slashType else {
            return retStr
        }
        var prefix = ""
        for type in slashTypeList  {
            retStr += prefix + type.rawValue
            prefix = ", "
        }
        return retStr
    }
    
    public func setOrderInfo(slashTypeList: [SlashListType], cId: Int32) {
        self.slashType = slashTypeList
        self.customerId = cId
    }
    
    public func getCustomerById(cId: Int32) -> Customer? {
        guard let customerInfo = entityGetter.getCustomer(id: cId) else {
            return nil
        }
        return customerInfo
    }
    
    public func getSlashTypeFromDb(){
        self.viewModel.pickItemList.value = ["中間長", "眼尾長", "齊長"]
    }
    
    public func getSlashTopLenFromDb() {
        // 6,7,8,9,10,11,12,13,14,15, 8-10,9-11,10-12,11-13
        self.viewModel.pickItemList.value = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "8-10", "9-11", "10-12", "11-13"]
    }
    
    public func getSlashTopCurlFromDb() {
        // J/B/C/CC/D/U/L+
        self.viewModel.pickItemList.value = ["J", "B", "C", "CC", "D", "U", "L+"]
    }
    
    public func getSlashTopSizeFromDb() {
        // 0.07 / 0.1
        self.viewModel.pickItemList.value = ["0.07", "0.08", "0.09", "0.1"]
    }
    
    public func getSlashBottLenFromDb() {
        // 6,7,8
        self.viewModel.pickItemList.value = ["6", "7", "8"]
    }
    
    public func getSlashBottCurlFromDb() {
        // J,B,C
        self.viewModel.pickItemList.value = ["J", "B", "C"]
    }
    
    public func getSlashBottSizeFromDb() {
        // J,B,C
        self.viewModel.pickItemList.value = ["0.07", "0.01", "0.15", "0.1扁毛"]
    }
    
    public func getDoerFromDb() {
        self.viewModel.pickItemList.value = ["Jen", "JaJen"]
    }
    
    public func setOderToDb() {
        
    }
    
    public func addSlashType() {
        
    }
}
