//
//  Customer_discount+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/1.
//
//

import Foundation
import CoreData


extension Customer_discount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer_discount> {
        return NSFetchRequest<Customer_discount>(entityName: "Customer_discount")
    }

    @NSManaged public var id: Int64
    @NSManaged public var user_id: Int32
    @NSManaged public var rule_id: Int16
    @NSManaged public var remain_money: Int16

}

extension Customer_discount : Identifiable {

}
