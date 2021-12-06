//
//  BillCheckController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckController {
    let viewModel: BillCheckModel
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    let defaultDbChecker = DefaultDbDataChecker()
    init(
        viewModel: BillCheckModel = BillCheckModel()
    ) {
        self.viewModel = viewModel
        self.viewModel.payMethodArr = self.getPayMethod().sorted{
            firstArr, sencondArr in
            return firstArr.value < sencondArr.value
        }
        self.viewModel.discountRule = self.getStoreRule()
    }
    
    public func setOrderDetail(detail: OrderEntityType) {
        viewModel.orderOfCustomer = detail
    }
    
    public func getPayMethod() -> [String : Double] {
        return defaultDbChecker.checkPayMethod()
    }
    
    public func getPayMethodRatio () -> Double{
        var methodRatio: Double = 1.0
        if let selectedPayMethod = viewModel.lastSelectionInex, let methodArr = viewModel.payMethodArr {
            let selectedIndex = methodArr.index(methodArr.startIndex, offsetBy: selectedPayMethod.row)
            methodRatio = methodArr.map{$0.value}[selectedIndex]
        }
        return methodRatio
    }
    
    public func getProfit() {
    }
    
    public func getStoreRule() -> [DiscountRule] {
        return defaultDbChecker.checkDiscountRule()
    }
    
    public func getCustomer(id: Int32) -> Customer? {
        return entityGetter.getCustomer(id: id)
    }
    
    public func getCustomerDiscount(uId: Int32) -> [CustomerDiscount]{
        guard let retArr = entityGetter.getCustomerDiscount(uId: uId) else {
            return []
        }
        return retArr
    }
    
    public func storeCustomerDiscountRuleToDb(ruleId: Int16) -> Int64? {
        guard let orderTmp = self.viewModel.orderOfCustomer else {return nil}
        return entitySetter.createCustomerDiscount(uId: orderTmp.user_id, ruleId: ruleId)
    }
    
    public func getDiscountRuleValue(ruleId: Int16) -> Int16{
        guard let ruleDetail = entityGetter.getDiscountRule(id: ruleId) else {
            return 0
        }
        let retActualMoney: Int16 = ruleDetail.total + ruleDetail.discount_add
        return retActualMoney
    }
    public func getCalcResult(price: String, shouldSave: Bool) -> Int16{
        guard
            var price: Int16 = Int16(price),
            let orderTmp = self.viewModel.orderOfCustomer
        else {
                return 0
            }
        let cId = orderTmp.user_id
        if let selectedRule = self.viewModel.selectedDiscountRuleId, shouldSave{
            let _ = storeCustomerDiscountRuleToDb( ruleId: selectedRule)
        }
        let allSDiscountOfCustomer = entityGetter.getCustomerDiscount(withMoneyLeft: cId)
        if allSDiscountOfCustomer.count > 0 {
            var souldDoneCal = false
            for customerDiscount in allSDiscountOfCustomer {
                var saveBackMoney: Int16 = 0
                if (customerDiscount.remain_money > price) {
                    souldDoneCal = true
                    saveBackMoney = customerDiscount.remain_money - price
                    price = 0
                } else {
                    price = price - customerDiscount.remain_money
                    saveBackMoney = 0
                }
                if shouldSave {
                    let _ = entitySetter.updateCustomerDiscount(id: customerDiscount.id, remain: saveBackMoney)
                }
                if souldDoneCal {
                    break
                }
            }
        }
        
        if price > 0 && !shouldSave{
            if let selectedRule = self.viewModel.selectedDiscountRuleId {
                let storeMoneyThisTime = self.getDiscountRuleValue(ruleId: selectedRule)
                if storeMoneyThisTime > price {
                    let _ = storeMoneyThisTime - price
                    price = 0
                } else {
                    price = price - storeMoneyThisTime
                }
            }
        }
        return price
    }
    
    public func getCurrentRemainMoney() -> Int16{
        var savedMoney: Int16 = 0
        guard let orderTmp = self.viewModel.orderOfCustomer else {return savedMoney}
        let cId = orderTmp.user_id
        let allSDiscountOfCustomer = entityGetter.getCustomerDiscount(withMoneyLeft: cId)
        if allSDiscountOfCustomer.count > 0 {
            for customerDiscount in allSDiscountOfCustomer {
                savedMoney +=  customerDiscount.remain_money
            }
        }
        return savedMoney
    }
    
    public func getCurrentRemainMoney(price: String) -> Int16{
        var savedMoney = getCurrentRemainMoney()
        if let selectedRule = self.viewModel.selectedDiscountRuleId {
            let storeMoneyThisTime = self.getDiscountRuleValue(ruleId: selectedRule)
            savedMoney = savedMoney + storeMoneyThisTime
        }
        guard let price: Int16 = Int16(price) else {
            return savedMoney
        }
        if price > savedMoney {
            savedMoney = 0
        } else {
            savedMoney = savedMoney - price
        }
        return savedMoney
    }
    
    public func saveRemainMoneyToCustomer(remain: Int16) {
        guard let orderTmp = self.viewModel.orderOfCustomer else {return}
        let cId = orderTmp.user_id
        let _ = entitySetter.updateCustomer(id: cId, remain: remain)
    }
}
