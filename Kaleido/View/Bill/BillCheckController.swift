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
    let defaultDbChecker = DefaultDbDataChecker()
    init(
        viewModel: BillCheckModel = BillCheckModel()
    ) {
        self.viewModel = viewModel
        self.viewModel.payMethodArr = self.getPayMethod()
        self.viewModel.discountRule = self.getStoreRule()
    }
    
    public func setOrderDetail(detail: OrderEntityType) {
        viewModel.orderOfCustomer = detail
    }
    
    public func getPayMethod() -> [String : Double] {
        return defaultDbChecker.checkPayMethod()
    }
    
    public func getStoreRule() -> [DiscountRule] {
        return defaultDbChecker.checkDiscountRule()
    }
    
    public func getCustomer(id: Int32) -> Customer? {
        return entityGetter.getCustomer(id: id)
    }
    
    public func getCustomerDiscount(uId: Int32) -> [CustomerDiscount]{
        guard let retArr = entityGetter.getCustomerDiscount(uId: uId) else {
            return []
        }
        return retArr
    }
    
    public func checkAddMoney(money: String) -> Int16{
        return 0
    }
    
    public func getCalcResult(price: String, remain: String, add: Int16, ratio: Double) -> Int16{
        guard
            let price: Int16 = Int16(price),
            let remain: Int16 = Int16(remain) else {
                return 0
            }
        
        
        return 0
    }
}
