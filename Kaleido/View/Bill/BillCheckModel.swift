//
//  BillCheckModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckModel {
    var orderOfCustomer: OrderEntityType?
    var payMethodArr: [String: Double]?
    var lastSelectionInex: IndexPath?
    var discountRule : [DiscountRule]?
}
