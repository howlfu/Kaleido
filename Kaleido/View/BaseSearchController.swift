//
//  BaseController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/26.
//

import Foundation

class BaseSearchController {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    lazy var entityDeleter: EntityDelHelper = EntityDelHelper(entity: entitySerice, get: entityGetter)
    var dbSearchDataCache:  [Customer]?
    
    init() {
        self.dbSearchDataCache = nil
    }
    
    func getCustomerFromDb() -> [Customer] {
//        dbSearchDataCache = testSearchData
        guard let allCustomer: [Customer] = entityGetter.getAllCustomerEntitys(rows: 5) else {
            return []
        }
        return allCustomer
    }
    
    func getCustomerFromDb(name: String, phone: String, birthday: String) -> [Customer] {
//        dbSearchDataCache = testSearchData
        guard let allCustomer: [Customer] = entityGetter.getCustomer(name: name, birthday: birthday, phone: phone) else {
            return []
        }
        return allCustomer
    }
    
    func setCustomerDataToDb(name: String, phone: String, birth: String, complete: (Bool) -> Void) {
     
        if entitySetter.createCustomer(name: name, birthday: birth, phone: phone) {
            //renew
            complete(true)
        } else {
            complete(false)
        }
    }
    
    func delectCustomer(cId: Int32) -> Bool{
        return entityDeleter.delectCustomer(id: cId)
    }
    
    func getOrders(by customerId: Int32) -> [Order] {
//        dbSearchDataCache = testSearchData
        guard let allOrders: [Order] = entityGetter.getOrders(uId: customerId) else {
            return []
        }
        return allOrders
    }
}
