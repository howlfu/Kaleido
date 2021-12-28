//
//  DemoShowController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/28.
//

import Foundation
class DemoShowController {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    let viewModel: DemoShowModel
    init(
        viewModel: DemoShowModel = DemoShowModel()
    ) {
        self.viewModel = viewModel
    }
    public func getAllCustomerBindingImage() {
        guard let customerId = self.viewModel.custmerId else {
            return
        }
        
        
    }
}
