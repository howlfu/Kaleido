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
        entityOfCustomer.remain_money = 0
        entityOfCustomer.created_at = Date()
        let _ = crudService.saveData()
        return true
    }
    
    public func updateCustomer(id: Int32, remain: Int16) -> Bool{
        guard let getCustomer: Customer = getHelper.getCustomer(id: id) else {
            return false
        }
        getCustomer.remain_money = remain
        if !crudService.saveData(){
            return false
        }
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
    
    public func createOrder(uId: Int32, prodId: Int64, services: String, storeMoney: Int16, totalPrice: Int16, income: Int16, doer: String, note:String, payMethod: String, date: Date) -> Bool{
        
        guard let entityOfOrder: Order = crudService.addNewToEntity(name: EntityNameDefine.order) else {
            
            return false
        }
        entityOfOrder.id = getIdFromeDefault(by: UserDefaultKey.orderId)
        entityOfOrder.user_id = uId
        entityOfOrder.product_id = prodId
        entityOfOrder.service_content = services
        entityOfOrder.store_money = storeMoney
        entityOfOrder.total_price = totalPrice
        entityOfOrder.income = income
        entityOfOrder.pay_method = ""
        entityOfOrder.doer = doer
        entityOfOrder.note = note
        entityOfOrder.created_at = date
        let _ = crudService.saveData()
        return true
    }
    
    public func updateOrder(by id: Int32, order: Order) -> Bool{
        guard let getCustomer: Order = getHelper.getOrder(id: id) else {
            return false
        }
        getCustomer.product_id = order.product_id
        getCustomer.service_content = order.service_content
        getCustomer.store_money = order.store_money
        getCustomer.total_price = order.total_price
        getCustomer.pay_method = order.pay_method
        getCustomer.income = order.income
        getCustomer.doer = order.doer
        getCustomer.note = order.note
        let _ = crudService.saveData()
        return true
    }
    
    public func createDiscountRule(name: String, total: Int16, ratio: Double, add: Int16) -> Int16? {

        let entityDiscRule = EntityNameDefine.discountRule
        guard let custDisc: DiscountRule = crudService.addNewToEntity(name: entityDiscRule) else {
            return nil
        }
        let typeId = getIdFromeDefault16(by: UserDefaultKey.discountRule)
        custDisc.id = typeId
        custDisc.name = name
        custDisc.total = total
        custDisc.ratio = ratio
        custDisc.discount_add = add
        let _ = crudService.saveData()
        return typeId
    }
    
    public func updateDiscountRule(id: Int16, name: String, total: Int16, ratio: Double, add: Int16) -> Bool {
        guard let discRule: DiscountRule = getHelper.getDiscountRule(id: id) else {
            return false
        }
        discRule.name = name
        discRule.total = total
        discRule.ratio = ratio
        discRule.discount_add = add
        if !crudService.saveData(){
            return false
        }
        return true
    }

    public func createCustomerDiscount(uId: Int32, ruleId: Int16) -> Int64? {

        let entityCustDisc = EntityNameDefine.customerDiscount
        guard let custDisc: CustomerDiscount = crudService.addNewToEntity(name: entityCustDisc) else {
            return nil
        }
        let typeId = getIdFromeDefault64(by: UserDefaultKey.customerDiscount)
        custDisc.id = typeId
        custDisc.user_id = uId
        custDisc.rule_id = ruleId
        custDisc.create_at = Date()
        if let discRule = getHelper.getDiscountRule(id: ruleId) {
            custDisc.remain_money = discRule.total + discRule.discount_add
        }
        let _ = crudService.saveData()
        return typeId
    }
    
    public func updateCustomerDiscount(id: Int64, remain: Int16) -> Bool {
        guard let custDisc: CustomerDiscount = getHelper.getCustomerDiscount(id: id) else {
            return false
        }
        //update other when get uniq customer
        custDisc.remain_money = remain
        if !crudService.saveData(){
            return false
        }
        return true
    }
    
    public func createProductType(refId: Int32, name: String) -> Int64? {
        guard getHelper.getProductType(refId: refId, name: name) == nil else {
            return nil
        }
        let entityName = EntityNameDefine.productType
        guard let productType: ProductType = crudService.addNewToEntity(name: entityName) else {
            return nil
        }
        let typeId = getIdFromeDefault64(by: UserDefaultKey.productType)
        productType.id = typeId
        productType.ref_id_1 = refId
        productType.name = name
        let _ = crudService.saveData()
        return typeId
        
    }
    
    public func createProductType(refId1: Int32, refId2: Int32,name: String) -> Int64? {
        guard getHelper.getProductType(refId1: refId1,refId2: refId2, name: name) == nil else {
            return nil
        }
        let productType = EntityNameDefine.productType
        guard let productType: ProductType = crudService.addNewToEntity(name: productType) else {
            return nil
        }
        let typeId = getIdFromeDefault64(by: UserDefaultKey.productType)
        productType.id = typeId
        productType.ref_id_1 = refId1
        productType.ref_id_2 = refId2
        productType.name = name
        let _ = crudService.saveData()
        return typeId
    }
    
    public func createProductLashTopBott(top_color: String, top_size: String, top_type: String, top_total_quantity: Int16, left_1: String, left_2: String, left_3: String, left_4: String, left_5: String, right_1: String, right_2: String, right_3: String, right_4: String, right_5: String, bott_length: String, bott_size: String, bott_total_quantity: Int16, bott_curl: String) -> Int64? {
        let productTypeName = EntityNameDefine.productLashTop + "_" + EntityNameDefine.productLashBott
        if let existProduct1:ProductLashTop = getHelper.getProductTopLash(color: top_color, size: top_size, type: top_type, total_quantity: top_total_quantity, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5), let existProduct2:ProductLashBott = getHelper.getProductBottLash(length: bott_length, size: bott_size, total_quantity: bott_total_quantity, curl: bott_curl) {
                guard let getId = checkProductInDb(entityName: productTypeName, prodId1: existProduct1.id, prodId2: existProduct2.id) else {
                    return nil
                }
                return getId
        } else {
            var savedId1:Int32 = 0
            if let existProduct1:ProductLashTop = getHelper.getProductTopLash(color: top_color, size: top_size, type: top_type, total_quantity: top_total_quantity, left_1: left_1, left_2: left_2, left_3: left_3, left_4: left_4, left_5: left_5, right_1: right_1, right_2: right_2, right_3: right_3, right_4: right_4, right_5: right_5) {
                savedId1 = existProduct1.id
            } else {
                let topProdEntityName = EntityNameDefine.productLashTop
                guard let entityOfLashTop: ProductLashTop = crudService.addNewToEntity(name: topProdEntityName) else {
                    return nil
                }
                savedId1 = getIdFromeDefault(by: UserDefaultKey.lashTopId)
                entityOfLashTop.id = savedId1
                entityOfLashTop.color = top_color
                entityOfLashTop.top_size = top_size
                entityOfLashTop.type = top_type
                entityOfLashTop.total_quantity = top_total_quantity
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
            }
            var savedId2: Int32 = 0
            if let existProduct2:ProductLashBott = getHelper.getProductBottLash(length: bott_length, size: bott_size, total_quantity: bott_total_quantity, curl: bott_curl) {
                savedId2 = existProduct2.id
            } else {
                let bottProdEntityName = EntityNameDefine.productLashBott
                guard let entityOfLashBott: ProductLashBott = crudService.addNewToEntity(name: bottProdEntityName) else {
                    return nil
                }
                savedId2 = getIdFromeDefault(by: UserDefaultKey.lashBottId)
                entityOfLashBott.id = savedId2
                entityOfLashBott.length = bott_length
                entityOfLashBott.bott_size = bott_size
                entityOfLashBott.total_quantity = bott_total_quantity
                entityOfLashBott.curl = bott_curl
            }
            guard let productId: Int64 = self.createProductType(refId1: savedId1, refId2: savedId2, name: productTypeName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
        
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
            entityOfLashTop.top_size = size
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
            let _ = crudService.saveData()
            guard let productId: Int64 = self.createProductType(refId: savedId, name: productTypeName) else {
                return nil
            }
            let _ = crudService.saveData()
            return productId
        }
    }
    
    public func createProductLashBott(length: String, size: String, total_quantity: Int16, curl: String) -> Int64? {
        let productTypeName = EntityNameDefine.productLashBott
        if let existProduct:ProductLashBott = getHelper.getProductBottLash(length: length, size: size, total_quantity: total_quantity, curl: curl) {
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
            entityOfLashBott.bott_size = size
            entityOfLashBott.total_quantity = total_quantity
            entityOfLashBott.curl = curl
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
    
    private func checkProductInDb(entityName: String, prodId1: Int32, prodId2: Int32) -> Int64?{
        guard let prodTypeExist = self.getHelper.getProductType(refId1: prodId1, refId2: prodId2, name: entityName) else {
            guard let productId: Int64 = self.createProductType(refId1: prodId1, refId2: prodId2, name: entityName) else {
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
    
    private func getIdFromeDefault16(by keyName: String) -> Int16{
        guard let id = UserDefaults.standard.string(forKey: keyName)
        else {
            UserDefaults.standard.setValue(1, forKey: keyName)
            return 1
        }
        if var intId = Int16(id) {
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
