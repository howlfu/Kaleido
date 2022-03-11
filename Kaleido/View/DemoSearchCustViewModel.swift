//
//  DemoSearchCustController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation

class DemoSearchCustViewModel: BaseSearchController {
    var customerOders: [Order] = [] {
        didSet {
            guard let cloure = self.customerOderClosure else {
                return
            }
            cloure(self.customerOders)
        }
    }
    var customerData: Customer? = nil{
        didSet {
            guard let cloure = self.customerDataClosure, let data =  self.customerData else {
                return
            }
            cloure(data)
        }
    }
    
    var customerOderClosure: (([Order]) -> ())?
    var customerDataClosure: ((Customer) -> ())?
    public func tryGetDataFromDb(name: String, phone: String, birthday: String) {
        let customerDetail = self.getCustomerFromDb(name: name, phone: phone, birthday: birthday)
        guard customerDetail.count == 1 else {
            return
        }
        let customerData = customerDetail[0]
        self.customerData = customerData
        let cId = customerData.id
        let orders = self.getOrders(by: cId)
        self.customerOders = orders
    }
    
    private func getStoreMoneyOrder(cId: Int32) -> [Order] {
        guard let allStoreRecords = entityGetter.getCustomerDiscount(uId: cId) else {
            return []
        }
        var retOrderArr:[Order] = []
        for storeRecord in allStoreRecords {
            let orderId = storeRecord.order_id
            if let orderDetail = entityGetter.getOrder(id: orderId) {
                retOrderArr.append(orderDetail)
            }
        }
        return retOrderArr
        
    }
}
