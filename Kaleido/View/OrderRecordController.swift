//
//  OrderRecordController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/26.
//

import Foundation

enum OrderRecordView {
    case order
    case store
}

class OrderRecordController: BaseSearchController {
    let viewModel: OrderRecordModel
    init(
        viewModel: OrderRecordModel = OrderRecordModel()
    ) {
        self.viewModel = viewModel
    }
    
    var setNextDest: OrderRecordView? {
        didSet {
            self.viewModel.btnDestination = self.setNextDest
        }
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
    
    public func didSelectTimePicker() {
        self.viewModel.didSelectTimePicker = true
    }
    
    public func deleteOrderFromDb(id: Int32) -> Bool {
        let isDone = entityDeleter.deleteOrder(id: id)
        self.viewModel.didDeleteOrder.value = isDone
        return isDone
    }
}
