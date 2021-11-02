//
//  SearchCustomsController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/2.
//

import Foundation

class SearchCustomsController {
    let viewModel: SearchCustomsModel
    var dbSearchDataCache:  Dictionary<String, String>?
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
    
    func getDataFromDb() -> Dictionary<String, String> {
        dbSearchDataCache = testSearchData
        return testSearchData
    }
    
    func setDataToDb(name: String, phone: String) {
        guard var dbData = dbSearchDataCache else {
            self.tryGetDataFromDb()
            return
        }
        let keyExists = dbData[name] != nil
        if (!keyExists) {
            dbData[name] = phone
        }
        
        self.viewModel.customDataModel.value = dbData
    }
}
