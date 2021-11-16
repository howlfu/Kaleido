//
//  ProductType+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/16.
//
//

import Foundation
import CoreData


extension ProductType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductType> {
        return NSFetchRequest<ProductType>(entityName: "ProductType")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var ref_id: Int32

}

extension ProductType : Identifiable {

}
