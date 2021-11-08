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
}
