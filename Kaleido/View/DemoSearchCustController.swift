//
//  DemoSearchCustController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation

class DemoSearchCustController: BaseSearchController {
    let viewModel: DemoSearchCustModel
    init(
        viewModel: DemoSearchCustModel = DemoSearchCustModel()
    ) {
        self.viewModel = viewModel
    }
    
    func setDataToDb(name: String, phone: String, birth: String) {
        setCustomerDataToDb(name: name, phone: phone, birth: birth, complete: { isDone in
            if  isDone {
                tryGetDataFromDb(name: name,  phone: phone, birthday: birth)
            } else {
                self.tryGetDataFromDb()
            }
        })
    }
    
    func tryGetDataFromDb() {
        let dbData = dbSearchDataCache ?? getCustomerFromDb()
        self.viewModel.customDataModel.value = dbData
    }
    
    func tryGetDataFromDb(name: String, phone: String, birthday: String) {
        let dbData = self.getCustomerFromDb(name: name, phone: phone, birthday: birthday)
        self.viewModel.customDataModel.value = dbData
    }
    
    func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
}
