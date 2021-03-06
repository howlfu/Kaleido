//
//  LashOrderEntityType.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/15.
//

import Foundation

struct OrderEntityType {
    var id: Int32
    var doer: String
    var note: String
    var pay_method: String
    var product_id: Int64
    var store_money: Int16
    var total_price: Int16
    var income: Int16
    var user_id: Int32
    var created_date: Date
    var services: String
}
