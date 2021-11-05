//
//  EntityOperateHelper.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/4.
//

import Foundation

class EntityGetHelper {
    static let inst = EntityGetHelper()
    private let crudService = EntityCRUDService()
    
    public func getCustomer(id: Int) -> [Customer]? {
        let result: [Customer] = self.getCustomerByRule(with: "id=\(id)")
        return result
    }
    
    public func getCustomer(name: String) -> [Customer]? {
        let result: [Customer] = self.getCustomerByRule(with: "full_name='\(name)'")
        return result
    }
    
    public func getCustomer(birthday: String) -> [Customer]?{
        let result: [Customer] = self.getCustomerByRule(with: "birthday=\(birthday)")
        return result
    }
    
    public func getCustomer(phone: String) -> [Customer]?{
        let result: [Customer] = self.getCustomerByRule(with: "phone_number=\(phone)")
        return result
    }
    
    private func getCustomerByRule<T>(with rule: String) -> [T] {
        let EntityName = EntityNameDefine.customer.rawValue
        return self.getDataBase(entity: EntityName, rule: rule)
    }
    
    public func getAllCustomerEntitys() -> [Customer] {
        let EntityName = EntityNameDefine.customer.rawValue
        return getEntityAllDataBase(entity: EntityName)
    }
    
    public func getOrders(id: Int) -> [Order]?{
        let result: [Order] = self.getOrderByRule(with: "id=\(id)")
        return result
    }
    
    public func getOrders(uId: Int) -> [Order]?{
        let result: [Order] = self.getOrderByRule(with: "user_id=\(uId)")
        return result
    }
    
    public func getAllOrders() -> [Order]? {
        let EntityName = EntityNameDefine.order.rawValue
        return getEntityAllDataBase(entity: EntityName)
    }
    
    private func getOrderByRule<T>(with rule: String) -> [T] {
        let EntityName = EntityNameDefine.order.rawValue
        return self.getDataBase(entity: EntityName, rule: rule)
    }
    
    private func getDataBase<T>(entity: String, rule: String) -> [T] {
        let customerEntity = crudService.readData(name: entity, with: rule)
        var retData: [T] = []
        for customerData in customerEntity {
            if let getCustomer = customerData as? T{
                retData.append(getCustomer)
            }
        }
        return retData
    }
    
    private func getEntityAllDataBase<T>(entity: String) -> [T] {
        let entityAllData = crudService.readData(by: entity)
        var retData: [T] = []
        for singleData in entityAllData {
            if let custSingleData = singleData as? T{
                retData.append(custSingleData)
            }
        }
        return retData
    }
}
