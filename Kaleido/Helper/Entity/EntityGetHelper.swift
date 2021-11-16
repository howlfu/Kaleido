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
    
    public func getProductType(id: Int64) -> ProductType? {
        let rule = "id=\(id)"
        let getProdTypes = self.getProductType(rule: rule)
        guard  getProdTypes.count == 1 else {
            return nil
        }
        return getProdTypes[0]
    }
    
    public func getProductType(refId: Int32, name: String) -> ProductType? {
        let rule = "ref_id=\(refId) AND name='\(name)'"
        let getProdTypes = self.getProductType(rule: rule)
        guard  getProdTypes.count == 1 else {
            return nil
        }
        return getProdTypes[0]
    }
    
    private func getProductType(rule: String) -> [ProductType]{
        let EntityName = EntityNameDefine.prudcutType
        return self.getDataBase(entity: EntityName, rule: rule)
    }
    
//    public func getProductKeratinByProductTypeId(id: Int64) -> ProductKeratin? {
//        guard let typeDetail = self.getProductType(id: id) else {
//            return nil
//        }
//        let refId = typeDetail.ref_id
//        let name = typeDetail.name
//        
//    }
    
    public func getProductKeratins()  -> [KeratinOrderModel]{
        let EntityName = EntityNameDefine.prudcutKeratin
        return getEntityAllDataBase(entity: EntityName)
    }
    
    public func getProductKeratin(id: Int32) -> ProductKeratin?{
        let rule = "id=\(id)"
        let retKeratinArr: [ProductKeratin] = getProductKeratin(rule: rule)
        if retKeratinArr.count != 1 {
            return nil
        }
        return retKeratinArr[0]
    }
    
    public func getProductKeratin(type:String, softTime: Int16, stableTime: Int16, colorTime: Int16) -> ProductKeratin? {
        var rule: String = ""
        rule = addPrefAndTagetData(target: type, prefix: "type", rule: rule)
        rule = addPrefAndTagetData(target: String(softTime), prefix: "soft_time", rule: rule)
        rule = addPrefAndTagetData(target: String(stableTime), prefix: "stable_time", rule: rule)
        rule = addPrefAndTagetData(target: String(colorTime), prefix: "color_time", rule: rule)
        let retKeratinArr: [ProductKeratin] = getProductKeratin(rule: rule)
        if retKeratinArr.count != 1 {
            return nil
        }
        return retKeratinArr[0]
    }
    
    private func getProductKeratin(rule: String) -> [ProductKeratin]{
        let EntityName = EntityNameDefine.prudcutKeratin
        return self.getDataBase(entity: EntityName, rule: rule)
    }
    
    private func addPrefAndTagetData(target: String, prefix: String, rule: String) -> String {
        var retRule = ""
        if target != "" {
            var andPrefix = ""
            if rule != "" {
                andPrefix = " AND "
            }
            retRule =  rule + andPrefix + "\(prefix)='\(target)'"
        }
        return retRule
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
