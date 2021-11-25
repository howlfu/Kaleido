//
//  EntitySetHelper.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/5.
//

import Foundation

class EntitySetHelper {
    private let crudService: EntityCRUDService
    private let getHelper: EntityGetHelper
    init(entity: EntityCRUDService, get: EntityGetHelper) {
        crudService = entity
        getHelper = get
    }
    
    public func createCustomer(name: String, birthday: String, phone: String) -> Bool{
        if let _ = getHelper.getCustomer(name: name, birthday: birthday, phone: phone) {
            print("Create Customer fail, Exist")
            return false
        }
        
        guard let entityOfCustomer: Customer = crudService.addNewToEntity(name: EntityNameDefine.customer) else {
            
            return false
        }
        entityOfCustomer.id = getIdFromeDefault(by: UserDefaultKey.customerId)
        entityOfCustomer.birthday = birthday
        entityOfCustomer.full_name = name
        entityOfCustomer.phone_number = phone
        entityOfCustomer.created_at = Date()
        let _ = crudService.saveData()
        return true
    }
    
    public func updateCustomer(name: String, birthday: String, phone: String) -> Bool{
        guard let getCustomer: Customer = tryGetUniqCostomer(name: name, birthday: birthday, phone: phone) else {
            return false
        }
        //update other when get uniq customer
        if getCustomer.phone_number == phone {
            getCustomer.full_name = name
            getCustomer.birthday = birthday
            
        } else if getCustomer.birthday == birthday {
            getCustomer.phone_number = phone
            getCustomer.full_name = name
            
        } else if getCustomer.full_name == name {
            getCustomer.phone_number = phone
            getCustomer.birthday = birthday
        }
        
        if !crudService.saveData(){
            return false
        }
        return true
    }
    
    private func tryGetUniqCostomer(name: String, birthday: String, phone: String) -> Customer?{
        guard let sameName:[Customer] = getHelper.getCustomer(name: name) else{
            print("get customer by name fail")
           return nil
        }
        if sameName.count > 1 {
            guard let sameBirthday:[Customer] = getHelper.getCustomer(birthday: birthday) else {
                print("get customer by birthday fail")
               return nil
            }
            if sameBirthday.count > 1 {
                guard let samePhone:[Customer] = getHelper.getCustomer(phone: phone) else {
                    print("get customer by phone fail")
                   return nil
                }
                if samePhone.count > 1 {
                    print("Over two costomers have the same information")
                    return nil
                } else if samePhone.count == 1{
                    return samePhone.first
                }
            } else if sameBirthday.count == 1{
                return sameBirthday.first
            }
        } else if sameName.count == 1 {
            return sameName.first
        }
        return nil
    }
    
    public func createOrder(uId: Int32, prodId: Int64, storeMoney: Int16, totalPrice: Int16, remainMoney: Int16, doer: String, note:String) -> Bool{
        
        guard let entityOfOrder: Order = crudService.addNewToEntity(name: EntityNameDefine.order) else {
            
            return false
        }
        entityOfOrder.id = getIdFromeDefault(by: UserDefaultKey.orderId)
        entityOfOrder.user_id = uId
        entityOfOrder.product_id = prodId
        entityOfOrder.remain_money = remainMoney
        entityOfOrder.store_money = storeMoney
        entityOfOrder.total_price = totalPrice
        entityOfOrder.pay_method = 0
        entityOfOrder.doer = doer
        entityOfOrder.note = note
        entityOfOrder.created_at = Date()
        let _ = crudService.saveData()
        return true
    }
    
    public func updateOrder(by id: Int32, order: Order) -> Bool{
        guard let getCustomer: Order = getHelper.getOrder(id: id) else {
            return false
        }
        getCustomer.product_id = order.product_id
        getCustomer.remain_money = order.remain_money
        getCustomer.store_money = order.store_money
        getCustomer.total_price = order.total_price
        getCustomer.pay_method = order.pay_method
        getCustomer.doer = order.doer
        getCustomer.note = order.note
        let _ = crudService.saveData()
        return true
    }
    public func createProductType(refId: Int32, name: String) -> Int64? {
        guard getHelper.getProductType(refId: refId, name: name) == nil else {
            return nil
        }
        let productType = EntityNameDefine.productType
        guard let productType: ProductType = crudService.addNewToEntity(name: productType) else {
            return nil
        }
        let typeId = getIdFromeDefault64(by: UserDefaultKey.productType)
        productType.id = typeId
        productType.ref_id = refId
        productType.name = name
        let _ = crudService.saveData()
        return typeId
        
    }
    public func createProductLashTop(color: String, size: String, type: String, total_quantity: Int16, left_1: String, left_2: String, left_3: String, left_4: String, left_5: String, right_1: String, right_2: String, right_3: String, right_4: String, right_5: String) -> Int64? {
        let productTypeName = EntityNameDefine.productLashTop
        if let existProduct:ProductLashTop = getHelper.getProductTopLash(color: color, size: size, type: type, total_quantity: total_quantity, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5) {
            guard let getId = checkProductInDb(entityName: productTypeName, prodId: existProduct.id) else {
                return nil
            }
            return getId
        }else {
            guard let entityOfLashTop: ProductLashTop = crudService.addNewToEntity(name: productTypeName) else {
                return nil
            }
            let savedId = getIdFromeDefault(by: UserDefaultKey.lashTopId)
            entityOfLashTop.id = savedId
            entityOfLashTop.color = color
            entityOfLashTop.size = size
            entityOfLashTop.type = type
            entityOfLashTop.total_quantity = total_quantity
            entityOfLashTop.left_1 = left_1
            entityOfLashTop.left_2 = left_2
            entityOfLashTop.left_3 = left_3
            entityOfLashTop.left_4 = left_4
            entityOfLashTop.left_5 = left_5
            entityOfLashTop.right_1 = right_1
            entityOfLashTop.right_2 = right_2
            entityOfLashTop.right_3 = right_3
            entityOfLashTop.right_4 = right_4
            entityOfLashTop.right_5 = right_5
            guard let productId: Int64 = self.createProductType(refId: savedId, name: productTypeName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
    }
    
    public func createProductLashBott(length: String, size: String, total_quantity: Int16, type: String) -> Int64? {
        let productTypeName = EntityNameDefine.productLashBott
        if let existProduct:ProductLashBott = getHelper.getProductBottLash(length: length, size: size, total_quantity: total_quantity, type: type) {
            guard let getId = checkProductInDb(entityName: productTypeName, prodId: existProduct.id) else {
                return nil
            }
            return getId
        }else {
            guard let entityOfLashBott: ProductLashBott = crudService.addNewToEntity(name: productTypeName) else {
                return nil
            }
            let savedId = getIdFromeDefault(by: UserDefaultKey.lashBottId)
            entityOfLashBott.id = savedId
            entityOfLashBott.length = length
            entityOfLashBott.size = size
            entityOfLashBott.total_quantity = total_quantity
            entityOfLashBott.type = type
            guard let productId: Int64 = self.createProductType(refId: savedId, name: productTypeName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
    }
    
    public func createProductKeratin(type:String, softTime: Int16, stableTime: Int16, colorTime: Int16) -> Int64? {
        let productTypeName = EntityNameDefine.productKeratin
        if let existProduct:ProductKeratin = getHelper.getProductKeratin(type: type, softTime: softTime, stableTime: stableTime, colorTime: colorTime) {
            guard let getId = checkProductInDb(entityName: productTypeName, prodId: existProduct.id) else {
                return nil
            }
            return getId
        } else {
            guard let entityOfKeratin: ProductKeratin = crudService.addNewToEntity(name: productTypeName) else {
                return nil
            }
            let savedId = getIdFromeDefault(by: UserDefaultKey.keratinId)
            entityOfKeratin.id = savedId
            entityOfKeratin.type = type
            entityOfKeratin.soft_time = softTime
            entityOfKeratin.stable_time = stableTime
            entityOfKeratin.color_time = colorTime
            
            guard let productId: Int64 = self.createProductType(refId: savedId, name: productTypeName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
        
    }
    
    private func checkProductInDb(entityName: String, prodId: Int32) -> Int64?{
        guard let prodTypeExist = self.getHelper.getProductType(refId: prodId, name: entityName) else {
            guard let productId: Int64 = self.createProductType(refId: prodId, name: entityName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
        return prodTypeExist.id
    }
    
    private func getIdFromeDefault(by keyName: String) -> Int32{
        guard let id = UserDefaults.standard.string(forKey: keyName)
        else {
            UserDefaults.standard.setValue(1, forKey: keyName)
            return 1
        }
        if var intId = Int32(id) {
            intId += 1
            UserDefaults.standard.setValue(intId, forKey: keyName)
            return intId
        }
        return 1
    }
    
    private func getIdFromeDefault64(by keyName: String) -> Int64{
        guard let id = UserDefaults.standard.string(forKey: keyName)
        else {
            UserDefaults.standard.setValue(1, forKey: keyName)
            return 1
        }
        if var intId = Int64(id) {
            intId += 1
            UserDefaults.standard.setValue(intId, forKey: keyName)
            return intId
        }
        return 1
    }
}
