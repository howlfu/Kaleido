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
    
    
    public func tryGetDataFromDb(name: String, phone: String, birthday: String) {
        let customerDetail = self.getCustomerFromDb(name: name, phone: phone, birthday: birthday)
        guard customerDetail.count == 1 else {
            return
        }
        let customerData = customerDetail[0]
        self.viewModel.customerData.value = customerData
        let cId = customerData.id
        let orders = self.getOrders(by: cId)
        self.viewModel.customerOders.value = orders
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
    
    func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
}
