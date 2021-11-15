//
//  EntityOperateHelper.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/4.
//

import Foundation

class EntityGetHelper {
    private let crudService: EntityCRUDService
    
    init(entity: EntityCRUDService) {
        crudService = entity
    }
    
    public func getCustomer(id: Int32) -> Customer? {
        let result: [Customer] = self.getCustomerByRule(with: "id=\(id)")
        if result.isEmpty || result.count != 1 {
            return nil
        }
        return result[0]
    }
    
    public func getCustomer(name: String) -> [Customer]? {
        let result: [Customer] = self.getCustomerByRule(with: "full_name='\(name)'")
        if result.isEmpty {
            return nil
        }
        return result
    }
    
    public func getCustomer(birthday: String) -> [Customer]?{
        let result: [Customer] = self.getCustomerByRule(with: "birthday='\(birthday)'")
        if result.isEmpty {
            return nil
        }
        return result
    }
    
    public func getCustomer(phone: String) -> [Customer]?{
        let result: [Customer] = self.getCustomerByRule(with: "phone_number='\(phone)'")
        if result.isEmpty {
            return nil
        }
        return result
    }
    
    public func getCustomer(name: String, birthday: String, phone: String) -> [Customer]?{
        let result: [Customer]
        var rule: String = ""
        func addPrefAndTagetData(target: String, prefix: String) {
            if target != "" {
                var andPrefix = ""
                if rule != "" {
                    andPrefix = " AND "
                }
                rule +=  andPrefix + "\(prefix)='\(target)'"
            }
        }
        if name != "" {
            rule +=  "full_name='\(name)'"
        }
        addPrefAndTagetData(target: birthday, prefix: "birthday")
        addPrefAndTagetData(target: phone, prefix: "phone_number")
        
        result = self.getCustomerByRule(with: rule)
        if result.isEmpty {
            return nil
        }
        return result
    }
    
    private func getCustomerByRule<T>(with rule: String) -> [T] {
        let EntityName = EntityNameDefine.customer
        return self.getDataBase(entity: EntityName, rule: rule)
    }
    
    public func getAllCustomerEntitys(rows: Int) -> [Customer]?{
        let EntityName = EntityNameDefine.customer
        let result: [Customer] = getEntityAllDataBase(entity: EntityName, rows: rows)
        if result.isEmpty {
            return nil
        }
        return result
    }
    
    public func getOrder(id: Int32) -> Order?{
        let result: [Order] = self.getOrderByRule(with: "id=\(id)")
        return result[0]
    }
    
    public func getOrders(uId: Int32) -> [Order]?{
        let result: [Order] = self.getOrderByRule(with: "user_id=\(uId)")
        return result
    }
    
    public func getAllOrders() -> [Order]? {
        let EntityName = EntityNameDefine.order
        return getEntityAllDataBase(entity: EntityName)
    }
    
    private func getOrderByRule<T>(with rule: String) -> [T] {
        let EntityName = EntityNameDefine.order
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
    
    private func getEntityAllDataBase<T>(entity: String, rows: Int = 0) -> [T] {
        let entityAllData = crudService.readData(by: entity, limit: rows)
        var retData: [T] = []
        for singleData in entityAllData {
            if let custSingleData = singleData as? T{
                retData.append(custSingleData)
            }
        }
        return retData
    }
}
