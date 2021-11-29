//
//  BillCheckController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckController {
    let viewModel: BillCheckModel
    init(
        viewModel: BillCheckModel = BillCheckModel()
    ) {
        self.viewModel = viewModel
    }
    
    func setOrderDetail(detail: OrderEntityType) {
        viewModel.orderOfCustomer = detail
    }
}
