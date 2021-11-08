//
//  SearchCustomsModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/2.
//

import Foundation

class SearchCustomsModel {
    var customDataModel = Observable<[Customer]>(value: [])
    var didSelectTimePicker = false
}
