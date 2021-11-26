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
        let cId = customerDetail[0].id
        let orders = self.getOrders(by: cId)
        self.viewModel.customerOders.value = orders
    }
    
    func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
}
