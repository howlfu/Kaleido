//
//  ProductLashBott+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/25.
//
//

import Foundation
import CoreData


extension ProductLashBott {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductLashBott> {
        return NSFetchRequest<ProductLashBott>(entityName: "ProductLashBott")
    }

    @NSManaged public var id: Int32
    @NSManaged public var length: String?
    @NSManaged public var size: String?
    @NSManaged public var total_quantity: Int16
    @NSManaged public var type: String?

}

extension ProductLashBott : Identifiable {

}
