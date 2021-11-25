//
//  ProductLashTop+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//
//

import Foundation
import CoreData


extension ProductLashTop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductLashTop> {
        return NSFetchRequest<ProductLashTop>(entityName: "ProductLashTop")
    }

    @NSManaged public var color: String?
    @NSManaged public var left_1: String?
    @NSManaged public var id: Int32
    @NSManaged public var right_1: String?
    @NSManaged public var size: String?
    @NSManaged public var total_quantity: Int16
    @NSManaged public var type: String?
    @NSManaged public var left_2: String?
    @NSManaged public var right_2: String?
    @NSManaged public var left_3: String?
    @NSManaged public var right_3: String?
    @NSManaged public var right_4: String?
    @NSManaged public var right_5: String?
    @NSManaged public var left_4: String?
    @NSManaged public var left_5: String?

}

extension ProductLashTop : Identifiable {

}
