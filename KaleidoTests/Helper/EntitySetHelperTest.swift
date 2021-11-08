//
//  EntitySetHelper.swift
//  KaleidoTests
//
//  Created by Howlfu on 2021/11/8.
//

import XCTest
import CoreData
@testable import Kaleido

class EntitySetHelperTest: XCTestCase {
    var sut: EntityCRUDService!
    var setHelper: EntitySetHelper!
    var getHelper: EntityGetHelper!
    lazy var mockPersistantContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "KaleidoTests", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false // Make it simpler in test env
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )

                // Check if creating container wrong
                if let error = error {
                    fatalError("Create an in-mem coordinator failed \(error)")
                }
            }
            return container
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    func flushData(entityName: String) {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        try! mockPersistantContainer.viewContext.save()

    }
    
    override func setUp() {
        super.setUp()
//        initStubsOfCustomer()
        sut = EntityCRUDService(container: mockPersistantContainer)
        getHelper = EntityGetHelper(entity: sut)
        setHelper = EntitySetHelper(entity: sut, get: getHelper)
    }
    
    
    override func tearDown() {
        flushData(entityName: "Customer")
        super.tearDown()
    }
    
    func testEntityCreateCostomer() throws {
//        let isCreated = setHelper.createCustomer(name: "Test1", birthday: "1981年11月2日", phone: "0912345678")
//        
//        XCTAssertTrue(isCreated)
//        
//        let getCustomerById:[Customer] = getHelper.getCustomer(id: 1)!
//        let getCustomerByName:[Customer] = getHelper.getCustomer(name: "Test1")!
//        let getCustomerByBirth:[Customer] = getHelper.getCustomer(birthday: "1981年11月2日")!
//        let getCustomerByPhone:[Customer] = getHelper.getCustomer(phone: "0912345678")!
//        XCTAssertTrue((getCustomerById[0].full_name == getCustomerByName[0].full_name) && (getCustomerByBirth[0].full_name == getCustomerByPhone[0].full_name))
    }
}
