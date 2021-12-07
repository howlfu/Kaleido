//
//  OrderRecordController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/26.
//

import Foundation
class OrderRecordController: BaseSearchController {
    let viewModel: OrderRecordModel
    init(
        viewModel: OrderRecordModel = OrderRecordModel()
    ) {
        self.viewModel = viewModel
    }
    
    func tryGetDataFromDb(name: String, phone: String, birthday: String) {
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
    
    func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
}
