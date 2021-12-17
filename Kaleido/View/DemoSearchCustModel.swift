//
//  DemoSearchCustModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation
class DemoSearchCustModel {
    var customerOders = Observable<[Order]>(value: [])
    var customerData = Observable<Customer>(value: Customer())
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
}
