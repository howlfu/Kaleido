//
//  ProductType+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/30.
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
    @NSManaged public var ref_id_1: Int32
    @NSManaged public var ref_id_2: Int32

}

extension ProductType : Identifiable {

}
