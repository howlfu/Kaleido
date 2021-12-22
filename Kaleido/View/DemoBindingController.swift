//
//  DemoBindingController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//

import Foundation
class DemoBindingController: BaseSearchController {
    let viewModel: DemoBindingModel
    init(
        viewModel: DemoBindingModel = DemoBindingModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func getOrderData() -> Order? {
        return self.viewModel.orderData
    }
    
    public func setOrderInfo(data: Order) {
        self.viewModel.orderData = data
    }
}
