//
//  LashOderModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
class LashOrderModel {
    var pickItemList =  Observable<[String]>(value: [])
    var pickItemList2: [String] = []
    var shouldShow2Component = false
    var orderOfCustomer = Order()
}
