//
//  StoreMoney+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/9.
//
//

import Foundation
import CoreData


extension StoreMoney {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreMoney> {
        return NSFetchRequest<StoreMoney>(entityName: "StoreMoney")
    }

    @NSManaged public var user_id: Int32
    @NSManaged public var store: Int16
    @NSManaged public var remain: Int16
    @NSManaged public var cash: Int16
    @NSManaged public var order_id: Int64
    @NSManaged public var pay_method: String?

}

extension StoreMoney : Identifiable {

}
