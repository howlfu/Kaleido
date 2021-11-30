//
//  ProductLashBott+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/30.
//
//

import Foundation
import CoreData


extension ProductLashBott {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductLashBott> {
        return NSFetchRequest<ProductLashBott>(entityName: "ProductLashBott")
    }

    @NSManaged public var curl: String?
    @NSManaged public var id: Int32
    @NSManaged public var length: String?
    @NSManaged public var bott_size: String?
    @NSManaged public var total_quantity: Int16

}

extension ProductLashBott : Identifiable {

}
