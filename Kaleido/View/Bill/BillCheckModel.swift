//
//  BillCheckModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckModel {
    var orderOfCustomer: OrderEntityType?
    var payMethodArr: Array<(key: String, value: Double)>?
    var lastSelectionInex: IndexPath?
    var discountRule : [DiscountRule]?
    var selectedDiscountRuleId : Int16?
    var currentProfit : Int16?
    var customerDiscountId: Int64?
}
