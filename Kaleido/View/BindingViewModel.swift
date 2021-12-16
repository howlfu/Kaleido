//
//  BindingViewModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/16.
//

import Foundation
class BindingViewModel{
    var segueFromOtherViewType: otherViewBtnDestType?
    var tableViewDiscountData = Observable<Dictionary<Int16, Int16>>(value: [:])
    var tableViewPayMethodData = Observable<Dictionary<String, Double>>(value: [:])
}
