//
//  StoreRecordController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/10.
//

import Foundation
class StoreRecordController {
    let entitySerice = EntityCRUDService()
    private var orderData: Order?
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    
    public func getCustomerData() -> Customer? {
        guard let orderData = self.orderData else {
            return nil
        }
        return entityGetter.getCustomer(id: orderData.user_id)
    }
    
    public func getOrderData() -> Order? {
        return orderData
    }
    
    public func setOrderInfo(data: Order) {
        orderData = data
    }
}
