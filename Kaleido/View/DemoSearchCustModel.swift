//
//  DemoSearchCustModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/17.
//

import Foundation
class DemoSearchCustModel {
    var customDataModel = Observable<[Customer]>(value: [])
    var didSelectTimePicker: Bool = false
    var selectedCustomerId: Int32?
}
