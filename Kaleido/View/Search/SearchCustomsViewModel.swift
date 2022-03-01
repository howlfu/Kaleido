//
//  SearchCustomsController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/2.
//

import Foundation

class SearchCustomsViewModel: BaseSearchController {
    //hock
    var setDataToDbClosure: (()->())?
    
    //binding
    var setDataToDb: setToDBInfo? {
        didSet {
            self.setDataToDbDetail()
        }
    }
    
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
    //return value
    var cellViewData: [Customer]?
    
    public func gCellViewData() -> [Customer] {
        guard let retCells = cellViewData else {
            return []
        }
        return retCells
    }
    
    func setDataToDbDetail() {
        guard let savedData = setDataToDb else{
            return
        }
        setCustomerDataToDb(name: savedData.name, phone: savedData.phone, birth: savedData.birth, complete: { isDone in
            if  isDone {
                tryGetDataFromDb(name: savedData.name,  phone: savedData.phone, birthday: savedData.birth)
            } else {
                self.tryGetDataFromDb()
            }
        })
    }
    
    func tryGetDataFromDb() {
        let dbData = dbSearchDataCache ?? getCustomerFromDb()
        self.cellViewData = dbData
        self.setDataToDbClosure?()
    }
    
    func tryGetDataFromDb(name: String, phone: String, birthday: String) {
        let dbData = self.getCustomerFromDb(name: name, phone: phone, birthday: birthday)
        self.cellViewData = dbData
        self.setDataToDbClosure?()
    }
}
