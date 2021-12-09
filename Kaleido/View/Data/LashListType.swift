//
//  LashListType.swift
//  Kaleido
//
//  Created by Howlfu on 2021/10/29.
//

import Foundation

enum LashListType: String, CaseIterable {
    case prefix = ", "
    case topLash = "上睫毛"
    case bottLash = "下睫毛"
    case addTopLash = "補上睫"
    case topAndBott = "上＋下"
    case removeRestart = "卸除重接"
    case removeOnly = "卸除"
    case lashSpa = "睫毛SPA"
    case lashSuite = "睫毛雨衣"
    case lashLiquid = "睫毛滋長液"
}
