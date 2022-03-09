//
//  BillCheckController.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//

import Foundation
class BillCheckViewModel {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    lazy var entityDeleter: EntityDelHelper = EntityDelHelper(entity: entitySerice, get: entityGetter)
    let defaultDbChecker = DefaultDbDataChecker()
    
    var orderOfCustomer: OrderEntityType?
    var payMethodArr: Array<(key: String, value: Double)>?
    var paymethodSelectIndex: IndexPath?
    var discountRule : [DiscountRule]?
    var selectedDiscountRuleId : Int16?
    var currentProfit : Int16?
    var customerDiscountId: Int64?
    var updateCalculateClosure: ((billCheckInfo) -> ())?
    public func start(
    ) {
        self.payMethodArr = self.getPayMethod().sorted{
            firstArr, sencondArr in
            return firstArr.value < sencondArr.value
        }
        self.discountRule = self.getStoreRule()
    }
    
    public func setOrderDetail(detail: OrderEntityType) {
        self.orderOfCustomer = detail
    }
    
    public func setOrderToDb(detail: OrderEntityType) -> Int32{
        let orderId = entitySetter.createOrder(uId: detail.user_id, prodId: detail.product_id, services: detail.services, storeMoney: detail.store_money, totalPrice: detail.total_price, income: detail.income, doer: detail.doer, note: detail.note, payMethod: detail.pay_method, date: detail.created_date)
        return orderId
    }
    
    public func getPayMethod() -> [String : Double] {
        return defaultDbChecker.checkPayMethod()
    }
    
     public func getPayMethodName() -> String{
        var methodName: String = ""
        if let selectedPayMethod = self.paymethodSelectIndex, let methodArr = self.payMethodArr {
            let selectedIndex = methodArr.index(methodArr.startIndex, offsetBy: selectedPayMethod.row)
            methodName = methodArr.map{$0.key}[selectedIndex]
        }
        return methodName
    }
    
    func getPayMethodRatio () -> Double{
        var methodRatio: Double = 0
        if let selectedPayMethod = self.paymethodSelectIndex, let methodArr = self.payMethodArr {
            let selectedIndex = methodArr.index(methodArr.startIndex, offsetBy: selectedPayMethod.row)
            methodRatio = methodArr.map{$0.value}[selectedIndex]
        }
        return methodRatio
    }
    
    public func getProfit() -> Int16{
        guard let retProfit = self.currentProfit else {
            return 0
        }
        return retProfit
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
    
    public func updateCustomerDiscount(id: Int64, orderId: Int32) {
        let _ = entitySetter.updateCustomerDiscount(id: id, orderId: orderId)
    }
    
    func storeCustomerDiscountRuleToDb(ruleId: Int16) -> Int64? {
        guard let orderTmp = self.orderOfCustomer else {return nil}
        return entitySetter.createCustomerDiscount(uId: orderTmp.user_id, ruleId: ruleId)
    }
    
    func removeCustomerDiscountFromDb(id: Int64) {
        guard let target = entityGetter.getCustomerDiscount(id: id) else {
            return
        }
        _ = entityDeleter.deleteCustomerDiscount(id: target.id)
    }
    
    func getDiscountRuleRatio(ruleId: Int16) -> Double{
        guard let ruleDetail = entityGetter.getDiscountRule(id: ruleId) else {
            return 0
        }
        return ruleDetail.ratio
    }
    
    private func getDiscountRuleValue(ruleId: Int16) -> Int16{
        guard let ruleDetail = entityGetter.getDiscountRule(id: ruleId) else {
            return 0
        }
        let retActualMoney: Int16 = ruleDetail.total + ruleDetail.discount_add
        return retActualMoney
    }
    
    public func handleCheckBtn(price: String, shouldSave: Bool) {
        let needPay = self.getCalcResult(price: price, shouldSave: shouldSave)
        let remainMoney = self.getCurrentRemainMoney(price: price)
        self.updateCalculateClosure?(billCheckInfo(needPay: needPay, remainStoredMoney: remainMoney))
    }
    
    public func handleSaveBtn(price: String, shouldSave: Bool) {
        let needPay  = self.getCalcResult(price: price, shouldSave: shouldSave)
        let remainMoney = self.getCurrentRemainMoney()
        guard var savedOrderTmp = self.orderOfCustomer else {
            print("Temporary order data not exist")
            return
        }
        let profit = self.getProfit()
        savedOrderTmp.income = profit
        savedOrderTmp.pay_method = self.getPayMethodName()
        savedOrderTmp.store_money = remainMoney
        savedOrderTmp.total_price = Int16(price) ?? 0
        let orderId = self.setOrderToDb(detail: savedOrderTmp)
        if let custDiscount = self.customerDiscountId {
            self.updateCustomerDiscount(id: custDiscount, orderId: orderId)
        }
        self.saveRemainMoneyToCustomer(remain: remainMoney)
    }
    
    func getCalcResult(price: String, shouldSave: Bool) -> Int16{
        var profit:Int16 = 0
        guard
            var priceInt: Int16 = Int16(price),
            let orderTmp = self.orderOfCustomer
        else {
                return 0
            }
        let cId = orderTmp.user_id
        if let selectedRule = self.selectedDiscountRuleId {
            self.customerDiscountId = self.storeCustomerDiscountRuleToDb(ruleId: selectedRule)
        }
        let allSDiscountOfCustomer = self.getCustomerDiscount(uId: cId)
        if allSDiscountOfCustomer.count > 0 {
            var souldDoneCal = false
            for customerDiscount in allSDiscountOfCustomer {
                var saveBackMoney: Int16 = 0
                let storeRuleRatio = self.getDiscountRuleRatio(ruleId: customerDiscount.rule_id)
                if (customerDiscount.remain_money > priceInt) {
                    souldDoneCal = true
                    saveBackMoney = customerDiscount.remain_money - priceInt
                    profit += Int16(Double(priceInt) * storeRuleRatio)
                    priceInt = 0
                } else {
                    priceInt = priceInt - customerDiscount.remain_money
                    profit += Int16(Double(customerDiscount.remain_money) * storeRuleRatio)
                    saveBackMoney = 0
                }
                if shouldSave {
                    updareRemainMoneyToDb(cdId: customerDiscount.id, saveBackMoney: saveBackMoney)
                }
                if souldDoneCal {
                    break
                }
            }
        }
        
        if !shouldSave {
            if let deleteId = self.customerDiscountId {
                removeCustomerDiscountFromDb(id: deleteId)
            }
        }
        let methodRatio = self.getPayMethodRatio()
        let pricePayByMethod = Int16(Double(priceInt) * methodRatio)
        self.currentProfit = profit + priceInt - pricePayByMethod
        return priceInt
    }
    
    func updareRemainMoneyToDb(cdId: Int64, saveBackMoney: Int16) {
        let _ = entitySetter.updateCustomerDiscount(id: cdId, remain: saveBackMoney)
    }
    
    func getCurrentRemainMoney() -> Int16{
        var savedMoney: Int16 = 0
        guard let orderTmp = self.orderOfCustomer else {return savedMoney}
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
        if let selectedRule = self.selectedDiscountRuleId {
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
        guard let orderTmp = self.orderOfCustomer else {return}
        let cId = orderTmp.user_id
        let _ = entitySetter.updateCustomer(id: cId, remain: remain)
    }
}
