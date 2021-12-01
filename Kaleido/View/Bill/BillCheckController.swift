//
//  BillCheckController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckController {
    let viewModel: BillCheckModel
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    
    init(
        viewModel: BillCheckModel = BillCheckModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func setOrderDetail(detail: OrderEntityType) {
        viewModel.orderOfCustomer = detail
    }
    
    public func getPayMethod() -> [String : Double] {
        return testPayMethod
    }
    
    public func getStoreRule() -> [Int : Int] {
        return testStoreRule
    }
    
    public func getCustomer(id: Int32) -> Customer? {
        return entityGetter.getCustomer(id: id)
    }
    
    public func getCalcResult(price: String, remain: String, add: String, ratio: Double) -> Int16{
        guard
            let add: Int16 = Int16(add),
            let price: Int16 = Int16(price),
            let remain: Int16 = Int16(remain) else {
                return 0
            }
        
        return 0
    }
}
