//
//  CustomerDiscount+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/14.
//
//

import Foundation
import CoreData


extension CustomerDiscount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerDiscount> {
        return NSFetchRequest<CustomerDiscount>(entityName: "CustomerDiscount")
    }

    @NSManaged public var create_at: Date?
    @NSManaged public var id: Int64
    @NSManaged public var remain_money: Int16
    @NSManaged public var rule_id: Int16
    @NSManaged public var user_id: Int32
    @NSManaged public var order_id: Int32

}

extension CustomerDiscount : Identifiable {

}
