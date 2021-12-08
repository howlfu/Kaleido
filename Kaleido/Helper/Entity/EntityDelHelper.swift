//
//  EntityDelHelper.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/19.
//

import Foundation
class EntityDelHelper {
    private let crudService: EntityCRUDService
    private let getHelper: EntityGetHelper
    init(entity: EntityCRUDService, get: EntityGetHelper) {
        crudService = entity
        getHelper = get
    }
    
    public func deleteCustomer(id: Int32) -> Bool{
        guard let target = self.getHelper.getCustomer(id: id) else {
            return false
        }
        crudService.deleteData(targetObj: target)
        return crudService.saveData()
    }
    
    public func deleteOrder(id: Int32) -> Bool{
        guard let target = self.getHelper.getOrder(id: id) else {
            return false
        }
        crudService.deleteData(targetObj: target)
        return crudService.saveData()
    }
    
    public func deleteCustomerDiscount(id: Int64) -> Bool{
        guard let target = self.getHelper.getCustomerDiscount(id: id) else {
            return false
        }
        crudService.deleteData(targetObj: target)
        return crudService.saveData()
    }
    
    public func deleteDiscountRule(id: Int16) -> Bool{
        guard let target = self.getHelper.getDiscountRule(id: id) else {
            return false
        }
        crudService.deleteData(targetObj: target)
        return crudService.saveData()
    }
    
}
