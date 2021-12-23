//
//  DemoBindingModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//

import UIKit
class DemoBindingModel {
    var pathSelected = Observable<[String]>(value: [])
    var imageSelected = Observable<Dictionary<String, UIImage>>(value: [:])
    var shouldUpdateTable = Observable<Bool> (value: false)
    var orderData: Order?
}
