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
    
    public func saveOrderKeratin(prodId: Int64, doer: String, note:String, setDate: Date, services: String) {
        self.viewModel.orderOfCustomer.product_id = prodId
        self.viewModel.orderOfCustomer.doer = doer
        self.viewModel.orderOfCustomer.note = note
        self.viewModel.orderOfCustomer.created_date = setDate
        self.viewModel.orderOfCustomer.services = services
    }
    
    public func setOrderForDemo(data: Order) {
        self.viewModel.orderOfCustomer.id = data.id
        self.viewModel.orderOfCustomer.doer = data.doer ?? ""
        self.viewModel.orderOfCustomer.note = data.note ?? ""
        self.viewModel.orderOfCustomer.product_id = data.product_id
        self.viewModel.orderOfCustomer.store_money = data.store_money
        self.viewModel.orderOfCustomer.total_price = data.total_price
        self.viewModel.orderOfCustomer.income = data.income
        self.viewModel.orderOfCustomer.user_id = data.user_id
        self.viewModel.orderOfCustomer.services = data.service_content ?? ""
        self.viewModel.orderOfCustomer.created_date = data.created_at ?? Date()
    }
    
    public func getKeratinOrder(id: Int32) -> ProductKeratin? {
        return entityGetter.getProductKeratin(id: id)
    }
    
    public func doDemoUpdate() {
        self.viewModel.demoOnly = true
    }
}
