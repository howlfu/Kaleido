//
//  Order+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/4.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var doer: String?
    @NSManaged public var id: Int32
    @NSManaged public var note: String?
    @NSManaged public var pay_method: Int16
    @NSManaged public var product_id: Int16
    @NSManaged public var remain_money: Int16
    @NSManaged public var store_money: Int16
    @NSManaged public var total_price: Int16
    @NSManaged public var user_id: Int32
    @NSManaged public var created_at: Date

}

extension Order : Identifiable {

}
