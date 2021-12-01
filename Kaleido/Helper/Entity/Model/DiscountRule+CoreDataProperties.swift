//
//  DiscountRule+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/1.
//
//

import Foundation
import CoreData


extension DiscountRule {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscountRule> {
        return NSFetchRequest<DiscountRule>(entityName: "DiscountRule")
    }

    @NSManaged public var discount_add: Int16
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var total: Int16
    @NSManaged public var ratio: Double

}

extension DiscountRule : Identifiable {

}
