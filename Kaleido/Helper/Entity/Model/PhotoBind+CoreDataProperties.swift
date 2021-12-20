//
//  PhotoBind+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/12/20.
//
//

import Foundation
import CoreData


extension PhotoBind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoBind> {
        return NSFetchRequest<PhotoBind>(entityName: "PhotoBind")
    }

    @NSManaged public var id: Int32
    @NSManaged public var user_id: Int32
    @NSManaged public var path: String?
    @NSManaged public var is_favorite: Bool
    @NSManaged public var order_id: Int32
    @NSManaged public var create_at: Date?

}

extension PhotoBind : Identifiable {

}
