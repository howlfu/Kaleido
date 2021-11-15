//
//  PayMethod+CoreDataProperties.swift
//  Kaleido
//
//  Created by Howlfu on 2021/11/15.
//
//

import Foundation
import CoreData


extension PayMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayMethod> {
        return NSFetchRequest<PayMethod>(entityName: "PayMethod")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var fee: Float

}

extension PayMethod : Identifiable {

}
