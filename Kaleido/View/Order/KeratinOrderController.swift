//
//  KeratinOrderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/12.
//

import Foundation
class KeratinOrderController: BaseOrderController {
    let viewModel: KeratinOrderModel
    init(
        viewModel: KeratinOrderModel = KeratinOrderModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func setOrderInfo(cId: Int32) {
        self.customerId = cId
        self.viewModel.orderOfCustomer.user_id = cId
    }
    
    public func getTypeListFromDb() {
        // L/M/S/東方L/東方M/東方S/
        self.viewModel.pickItemList.value = ["L", "M", "S", "東方L", "東方M", "東方S"]
    }
    
    public func saveProductOrder(type: String, softTime: String, stableTime: String, colorTime: String) -> Int64? {
        let softTimeInt = Int16(softTime) ?? 0
        let stableTimeInt = Int16(stableTime) ?? 0
        let colorTimeInt = Int16(colorTime) ?? 0
        guard let productId = entitySetter.createProductKeratin(type: type, softTime: softTimeInt, stableTime: stableTimeInt, colorTime: colorTimeInt) else {
            return nil
        }
        return productId
    }
    
    public func saveOrderKeratin(prodId: Int64, doer: String, note:String, setDate: Date) {
        self.viewModel.orderOfCustomer.product_id = prodId
        self.viewModel.orderOfCustomer.doer = doer
        self.viewModel.orderOfCustomer.note = note
        self.viewModel.orderOfCustomer.created_date = setDate
    }
}
