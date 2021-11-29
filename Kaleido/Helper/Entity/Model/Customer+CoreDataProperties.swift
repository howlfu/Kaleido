//
//  Customer+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/29.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var created_at: Date?
    @NSManaged public var full_name: String?
    @NSManaged public var id: Int32
    @NSManaged public var phone_number: String?
    @NSManaged public var remain_money: Int16

}

extension Customer : Identifiable {

}
