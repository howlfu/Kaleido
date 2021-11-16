//
//  LashOderModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
import UIKit
class LashOrderModel {
    var pickItemList =  Observable<[String]>(value: [])
    var pickItemList2: [String] = []
    var shouldShow2Component = false
    var orderOfCustomer = OrderEntityType(doer: "", note: "", pay_method: 0, product_id: 0, remain_money: 0, store_money: 0, total_price: 0, user_id: 0, created_date: Date())
}
