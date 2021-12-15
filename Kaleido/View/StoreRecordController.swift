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
    
    public func getCustomDiscountRule(orderId: Int32) -> CustomerDiscount? {
        return entityGetter.getCustomerDiscount(orderId: orderId)
    }
    
    public func getDiscountRule(ruleId: Int16) -> DiscountRule? {
        return entityGetter.getDiscountRule(id: ruleId)
    }
    
    public func getOrderData() -> Order? {
        return orderData
    }
    
    public func setOrderInfo(data: Order) {
        orderData = data
    }
}
