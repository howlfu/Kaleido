//
//  KeratinOrderModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/12.
//

import Foundation
class KeratinOrderModel {
    var pickItemList =  Observable<[String]>(value: [])
    var orderOfCustomer = OrderEntityType(doer: "", note: "", pay_method: 0, product_id: 0, store_money: 0, total_price: 0, user_id: 0, created_date: Date(), services: "")
}
