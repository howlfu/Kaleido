//
//  DefaultDbDataChecker.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/3.
//

import Foundation

class DefaultDbDataChecker {
    let entitySerice = EntityCRUDService()
    lazy var entityGetter: EntityGetHelper = EntityGetHelper(entity: entitySerice)
    lazy var entitySetter: EntitySetHelper = EntitySetHelper(entity: entitySerice, get: entityGetter)
    
    public func checkDiscountRule() -> [DiscountRule] {
        
        let defaultStoreRule = [
            DiscountRuleType(name: "rule1", total: 3000, discount_add: 300, ratio: 0.909),
            DiscountRuleType(name: "rule2", total: 6000, discount_add: 800, ratio: 0.8823),
            DiscountRuleType(name: "rule3", total: 10000, discount_add: 2000, ratio: 0.8333)
        ]
        let allRule = entityGetter.getDiscountRuleAll()
        guard allRule.count > 0 else {
            for storeRule in defaultStoreRule {
                let _ = entitySetter.createDiscountRule(name: storeRule.name, total: storeRule.total, ratio: storeRule.ratio, add: storeRule.discount_add
                )
            }
            return entityGetter.getDiscountRuleAll()
        }
        return allRule
    }
    
    public func checkPayMethod() -> Dictionary<String, Double> {
        let defaultPayMethodRule = [
            "LinePay": 0.0231,
            "街口": 0.025,
            "信用卡": 0.03
        ]
        let defaultKey = UserDefaultKey.storeRule
        guard let payMethodRule = UserDefaults.standard.value(forKey: defaultKey) as? Dictionary<String, Double> else {
            UserDefaults.standard.set(defaultPayMethodRule, forKey: defaultKey)
            return defaultPayMethodRule
        }
        return payMethodRule
    }
    
    public func updatePayMethod(key: String, val: Double) {
        let defaultKey = UserDefaultKey.storeRule
        var tmpPayMethod = checkPayMethod()
        tmpPayMethod[key] = val
        UserDefaults.standard.set(tmpPayMethod, forKey: defaultKey)
    }
}
