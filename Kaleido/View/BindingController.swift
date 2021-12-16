//
//  BindingController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/16.
//

import Foundation
class BindingController {
    let viewModel: BindingViewModel
    let defaultDbChecker = DefaultDbDataChecker()
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entityDeleter: EntityDelHelper = EntityDelHelper(entity: entitySerice, get: entityGetter)
    init(
        viewModel: BindingViewModel = BindingViewModel()
    ) {
        self.viewModel = viewModel
    }
    
    public func initTableViewData() {
        if let showType: otherViewBtnDestType = self.viewModel.segueFromOtherViewType {
            switch showType {
            case .discount:
                initDiscountTableList()
                
            case .payMethod:
                initPayMethodTableList()
            default:
                return
            }
        }
    }
    
    func initDiscountTableList() {
        let discountData = defaultDbChecker.checkDiscountRule()
        var tmpTableViewData: Dictionary<Int16, Int16> = [:]
        for singleData in discountData {
            tmpTableViewData[singleData.total] = singleData.discount_add
        }
        self.viewModel.tableViewDiscountData.value = tmpTableViewData
    }
    
    func initPayMethodTableList() {
        let payMethodData = defaultDbChecker.checkPayMethod()
        var tmpTableViewData: Dictionary<String, Double> = [:]
        for singleData in payMethodData {
            tmpTableViewData[singleData.key] = singleData.value
        }
        self.viewModel.tableViewPayMethodData.value = tmpTableViewData
    }
    
    public func deleteDiscountRule(total: Int16, add: Int16){
        guard let delTarget = self.entityGetter.getDiscountRule(name: "", total: total, add: add) else{
            return
        }
        _ = entityDeleter.deleteDiscountRule(id: delTarget.id)
    }
    
    public func deletePayMethod(keyVal: String) {
        defaultDbChecker.deletePayMethod(keyValue: keyVal)
    }
}
