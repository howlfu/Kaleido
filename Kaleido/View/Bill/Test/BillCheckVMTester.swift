//
//  BillCheckVMTester.swift
//  Kaleido
//
//  Created by Howlfu on 2022/3/7.
//

import Foundation
import CoreData

class BillCheckViewModelTester: BillCheckViewModel {
    var cusDiscountArr: [CustomerDiscount] = []
    var cusDisId:Int64 = 1
    var setCustDiscountRuleId: Int16 = 0
    var childContext1: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var childContext2: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var childContext3: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    public func cleanAll() {
        cusDiscountArr.removeAll()
    }
    override func storeCustomerDiscountRuleToDb(ruleId: Int16) -> Int64? {
        guard let orderTmp = self.orderOfCustomer else {return nil}
        var childContext: NSManagedObjectContext?
        switch ruleId {
            case 1:
                childContext = childContext1
            case 2:
                childContext = childContext2
            case 3:
                childContext = childContext3
        default:
            childContext = nil
        }
        let cusDiscount = CustomerDiscount(context: childContext!)
        let getRule = self.discountRule!.first{$0.id == ruleId}
        cusDiscount.id = self.cusDisId
        cusDiscount.rule_id = setCustDiscountRuleId
        cusDiscount.user_id = 1
        cusDiscount.order_id = orderTmp.id
        if let discRule = getRule {
            cusDiscount.remain_money = discRule.total + discRule.discount_add
        } else {
            cusDiscount.remain_money = 0
        }
        cusDiscount.create_at = Date()
        cusDiscountArr.append(cusDiscount)
        self.cusDisId += 1
        return 1
    }
    
    override func getCustomerDiscount(uId: Int32) -> [CustomerDiscount]{
        return cusDiscountArr
    }
    
    override func removeCustomerDiscountFromDb(id: Int64) {
        var removeIndex: Int = 0
        for custDist in cusDiscountArr {
            let cdistId = custDist.id
            if cdistId == id {
                break
            }
            removeIndex += 1
        }
        cusDiscountArr.remove(at: removeIndex)
    }
    
    override func getDiscountRuleRatio(ruleId: Int16) -> Double{
        var resultRatio: Double?
        guard let dRules = self.discountRule else {
            return 0
        }
        for dRule in dRules {
            if dRule.id == ruleId {
                resultRatio = dRule.ratio
            }
        }
        return resultRatio ?? 0
    }
    
    override func updareRemainMoneyToDb(cdId: Int64, saveBackMoney: Int16) {
        var removeIndex: Int = 0
        for custDist in cusDiscountArr {
            let cdistId = custDist.id
            if cdistId == cdId {
                custDist.remain_money = saveBackMoney
                break
            }
            removeIndex += 1
        }
    }
    
    override func getCurrentRemainMoney() -> Int16{
        var savedMoney: Int16 = 0
        for custDist in cusDiscountArr {
            savedMoney += custDist.remain_money
        }
        return savedMoney
    }
}
