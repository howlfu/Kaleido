
//
//  LashOderModel.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/9.
//

import Foundation
import UIKit
class LashOrderModel {
    var pickItemList =  Observable<[String]>(value: [])
    var segmentToggleLeft = Observable<Bool>(value: false)
    
    var pickItemList2: [String] = []
    var shouldShow2Component = false
    var orderOfCustomer = OrderEntityType(id: 0, doer: "", note: "", pay_method: "", product_id: 0, store_money: 0, total_price: 0, income: 0, user_id: 0, created_date: Date(), services: "")
    var leftLashData: LashPosType = LashPosType(text1: "", text2: "", text3: "", text4: "", text5: "")
    var rightLashData: LashPosType = LashPosType(text1: "", text2: "", text3: "", text4: "", text5: "")
    var demoOnly: Bool = false
    var isLashTopEnable:Bool = false
    var isLashBottEnable:Bool = false
    var switchStr: String = ""
}
