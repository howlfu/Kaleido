//
//  KeratinOrderController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/12.
//

import Foundation
class KeratinOrderViewModel: BaseOrderController {
    var pickItemList: [String] = [] {
        didSet{
            pickItemListClosure?(self.pickItemList)
        }
    }
    var orderOfCustomer = OrderEntityType(id: 0, doer: "", note: "", pay_method: "", product_id: 0, store_money: 0, total_price: 0, income: 0, user_id: 0, created_date: Date(), services: "")
    var pickItemListClosure: (([String]) -> ())?
    
    public func setOrderInfo(cId: Int32) {
        self.customerId = cId
        self.orderOfCustomer.user_id = cId
    }
    
    public func getTypeListFromDb() {
        // L/M/S/東方L/東方M/東方S/
        self.pickItemList = ["L", "M", "S", "東方L", "東方M", "東方S"]
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
        self.orderOfCustomer.product_id = prodId
        self.orderOfCustomer.doer = doer
        self.orderOfCustomer.note = note
        self.orderOfCustomer.created_date = setDate
        self.orderOfCustomer.services = services
    }
    
    public func setOrderForDemo(data: Order) {
        self.orderOfCustomer.id = data.id
        self.orderOfCustomer.doer = data.doer ?? ""
        self.orderOfCustomer.note = data.note ?? ""
        self.orderOfCustomer.product_id = data.product_id
        self.orderOfCustomer.store_money = data.store_money
        self.orderOfCustomer.total_price = data.total_price
        self.orderOfCustomer.income = data.income
        self.orderOfCustomer.user_id = data.user_id
        self.orderOfCustomer.services = data.service_content ?? ""
        self.orderOfCustomer.created_date = data.created_at ?? Date()
    }
    
    public func getKeratinOrder(id: Int32) -> ProductKeratin? {
        return entityGetter.getProductKeratin(id: id)
    }
}
