//
//  OrderRecordModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/26.
//

import Foundation
class OrderRecordModel {
    var customerOders = Observable<[Order]>(value: [])
    var customerData = Observable<Customer>(value: Customer())
    var didDeleteOrder = Observable<Bool>(value: false)
    var toDemoOrder: Order?
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
    var btnDestination: OrderRecordView?
}
