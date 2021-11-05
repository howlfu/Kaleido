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
    public func getCustomer(by name: String) -> [Customer]? {
        let result: [Customer] = self.getCustomerByRule(with: "full_name='\(name)'")
        return result
    }
    
//    public func getCustomer(by birthday: Date) -> [Customer]?{
//        let result: [Customer] = self.getCustomerByRule(with: "birthday=\(birthday)")
//        return result
//    }
    
    public func getCustomer(with phone: String) -> [Customer]?{
        let result: [Customer] = self.getCustomerByRule(with: "phone_number=\(phone)")
        return result
    }
    
    private func getCustomerByRule<T>(with rule: String) -> [T] {
        let EntityName = EntityNameDefine.customer.rawValue
        let customerEntity = crudService.readData(name: EntityName, with: rule)
        var retData: [T] = []
        for customerData in customerEntity {
            if let getCustomer = customerData as? T{
                retData.append(getCustomer)
            }
        }
        return retData
    }
    
    private func getAllCustomerEntity() -> [Customer] {
        let EntityName = EntityNameDefine.customer.rawValue
        let customerEntity = crudService.readData(by: EntityName)
        var retData: [Customer] = []
        for customerData in customerEntity {
            if let getCustomer = customerData as? Customer{
                retData.append(getCustomer)
            }
        }
        return retData
    }
    
    public func getOrders(by id: String) {
        
    }
    
    public func getOrders(with custName: String) {
        
    }
    
    private func getAllOrders() {
        
    }
    
    
}
