//
//  BaseOrderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/16.
//

import Foundation

class BaseOrderController {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    var customerId: Int32? = 0
    public func getCustomerName() -> String{
        guard
            let cId = customerId,
            let customer = entityGetter.getCustomer(id: cId),
            let name = customer.full_name
        else { return "" }
        return name
    }
    
    public func getProductData(id: Int64) -> ProductType? {
        return entityGetter.getProductType(id: id)
    }
    
    public func updateOrderToDb(order: OrderEntityType) {
        let _ = entitySetter.updateOrder(by: order.id, order: order)
    }
}
