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
        self.viewModel.pickItemList = ["中間長", "眼尾長", "齊長"]
    }
    
    public func getSlashTopSizeFromDb() {
        // 6,7,8,9,10,11,12,13,14,15, 8-10,9-11,10-12,11-13
        self.viewModel.pickItemList = ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "8-10", "9-11", "10-12", "11-13"]
    }
    
    public func setOderToDb() {
        
    }
    
    public func addSlashType() {
        
    }
}
