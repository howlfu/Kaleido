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
    
    public func delectCustomer(id: Int32) -> Bool{
        guard let targetCustomers = self.getHelper.getCustomer(id: id) else {
            return false
        }
        crudService.deleteData(targetObj: targetCustomers)
        return true
    }
    
}
