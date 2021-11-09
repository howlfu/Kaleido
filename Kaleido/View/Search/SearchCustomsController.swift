//
//  SearchCustomsController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/2.
//

import Foundation

class SearchCustomsController {
    let viewModel: SearchCustomsModel
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper =  EntityGetHelper(entity: entitySerice
    )
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    var dbSearchDataCache:  [Customer]?
    init(
        viewModel: SearchCustomsModel = SearchCustomsModel()
    ) {
        self.viewModel = viewModel
        self.dbSearchDataCache = nil
        
    }
    
    func tryGetDataFromDb() {
        let dbData = dbSearchDataCache ?? getDataFromDb()
        self.viewModel.customDataModel.value = dbData
    }
    
    func tryGetDataFromDb(name: String, phone: String, birthday: String) {
        let dbData = self.getDataFromDb(name: name, phone: phone, birthday: birthday)
        self.viewModel.customDataModel.value = dbData
    }
    
    func getDataFromDb() -> [Customer] {
//        dbSearchDataCache = testSearchData
        guard let allCustomer: [Customer] = entityGetter.getAllCustomerEntitys(rows: 5) else {
            return []
        }
        return allCustomer
    }
    
    func getDataFromDb(name: String, phone: String, birthday: String) -> [Customer] {
//        dbSearchDataCache = testSearchData
        guard let allCustomer: [Customer] = entityGetter.getCustomer(name: name, birthday: birthday, phone: phone) else {
            return []
        }
        return allCustomer
    }
    
    func setDataToDb(name: String, phone: String, birth: String) {
     
        if entitySetter.createCustomer(name: name, birthday: birth, phone: phone) {
            //renew
            tryGetDataFromDb(name: name,  phone: phone, birthday: birth)
        } else {
            self.tryGetDataFromDb()
        }
    }
    
    func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
}
