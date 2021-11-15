//
//  KeratinOrderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/12.
//

import Foundation
class KeratinOrderController {
    let viewModel: KeratinOrderModel
    init(
        viewModel: KeratinOrderModel = KeratinOrderModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func getTypeListFromDb() {
        // L/M/S/東方L/東方M/東方S/
        self.viewModel.pickItemList.value = ["L", "M", "S", "東方L", "東方M", "東方S"]
    }
}
