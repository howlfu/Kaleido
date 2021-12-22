//
//  DemoBindingModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//

import UIKit
class DemoBindingModel {
    var pathSelected = Observable<[String]>(value: [])
    var orderData: Order?
}
