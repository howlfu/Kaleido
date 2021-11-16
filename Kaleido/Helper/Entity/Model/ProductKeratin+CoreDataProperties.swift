//
//  ProductKeratin+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/15.
//
//

import Foundation
import CoreData


extension ProductKeratin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductKeratin> {
        return NSFetchRequest<ProductKeratin>(entityName: "ProductKeratin")
    }

    @NSManaged public var color_time: Int16
    @NSManaged public var id: Int32
    @NSManaged public var soft_time: Int16
    @NSManaged public var stable_time: Int16
    @NSManaged public var type: String?

}

extension ProductKeratin : Identifiable {

}
