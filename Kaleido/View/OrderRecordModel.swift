//
//  OrderRecordModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/26.
//

import Foundation
class OrderRecordModel {
    var customerOders = Observable<[Order]>(value: [])
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
    
}
