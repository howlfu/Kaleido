//
//  CoreDataCRUDTest.swift
//  KaleidoTests
//
//  Created by Howlfu on 2021/11/4.
//
import XCTest
import CoreData
@testable import Kaleido

class CoreDataCRUDTest: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    var sut: EntityCRUDService!
    
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
    
    func initStubsOfCustomer() {
            
        func insertCustomer( id: Int, full_name: String, phone_number: String, birthday: String, created_at: Date) -> Customer? {
            
            let obj = NSEntityDescription.insertNewObject(forEntityName: "Customer", into: mockPersistantContainer.viewContext)
            
            obj.setValue(id, forKey: "id")
            obj.setValue(full_name, forKey: "full_name")
            obj.setValue(phone_number, forKey: "phone_number")
            obj.setValue(birthday, forKey: "birthday")
            obj.setValue(created_at, forKey: "created_at")
            return obj as? Customer
        }
        
        _ = insertCustomer(id: 1, full_name: "Test_1", phone_number: "111", birthday: "2019年5月1日", created_at: Date())
        _ = insertCustomer(id: 2, full_name: "Test_2", phone_number: "222", birthday: "2019年5月2日", created_at: Date())
        _ = insertCustomer(id: 3, full_name: "Test_3", phone_number: "333", birthday: "2019年5月3日", created_at: Date())
        _ = insertCustomer(id: 4, full_name: "Test_4", phone_number: "444", birthday: "2019年5月4日", created_at: Date())
        _ = insertCustomer(id: 5, full_name: "Test_5", phone_number: "555", birthday: "2019年5月5日", created_at: Date())
        
        
            do {
                try mockPersistantContainer.viewContext.save()
            }  catch {
                print("create fakes error \(error)")
            }
        }
    
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
        initStubsOfCustomer()
        sut = EntityCRUDService(container: mockPersistantContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave , object: nil)
    }
    var saveNotificationCompleteHandler: ((Notification)->())?
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
            saveNotificationCompleteHandler = completeHandler
        }
    func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
    
    override func tearDown() {
        flushData(entityName: "Customer")
        super.tearDown()
    }

    func testReadDataByEntityName() throws {
        let allCustomer: [NSManagedObject] = sut.readData(by: "Customer")
        for oneCust in allCustomer {
            let full_name: String = oneCust.value(forKey: "full_name") as! String
            XCTAssertTrue(full_name.starts(with: "Test_"))
        }
        XCTAssertEqual(allCustomer.count, 5)
    }
    
    func testReadDataByRule() throws {
        var allCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "id=5")
        for oneCust in allCustomer {
            let phone: String = oneCust.value(forKey: "phone_number") as! String
            XCTAssertEqual(phone, "555")
        }
        XCTAssertEqual(allCustomer.count, 1)
        
        allCustomer = sut.readData(name: "Customer", with: "birthday='2019年5月3日'")
        for oneCust in allCustomer {
            let birth: String = oneCust.value(forKey: "birthday") as! String
            XCTAssertEqual(birth, "2019年5月3日")
        }
        XCTAssertEqual(allCustomer.count, 1)
        
    }
    
    func testAddEntity() throws {
        guard let entityInst = sut.addNewToEntity(name: "Customer") else {
            XCTAssertTrue(false)
            return
        }
        entityInst.setValue(6, forKey: "id")
        entityInst.setValue("Test_6", forKey: "full_name")
        entityInst.setValue("666", forKey: "phone_number")
        entityInst.setValue("2019年5月1日", forKey: "birthday")
        entityInst.setValue(Date(), forKey: "created_at")
        
        let allCustomer: [NSManagedObject] = sut.readData(by: "Customer")
        XCTAssertEqual(allCustomer.count, 6)
        
        let newCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "full_name='Test_6'")
        XCTAssertEqual(newCustomer.count, 1)
        guard let entityInst2 = sut.addNewToEntity(name: "Customer") else {
            XCTAssertTrue(false)
            return
        }
        entityInst2.setValue(7, forKey: "id")
        entityInst2.setValue("Test_6", forKey: "full_name")
        entityInst2.setValue("666", forKey: "phone_number")
        entityInst2.setValue("2019年5月1日", forKey: "birthday")
        entityInst2.setValue(Date(), forKey: "created_at")
        let twoCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "full_name='Test_6'")
        XCTAssertEqual(twoCustomer.count, 2)
        let saveSucc = sut.saveData()
        XCTAssertTrue(saveSucc)
    }
    
    func testUpdateData() throws {
        let testPhoneNum = "ttt"
        let newCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "full_name='Test_5'")
        let test5 = newCustomer[0]
        test5.setValue(testPhoneNum, forKey: "phone_number")
        let saveSucc = sut.saveData()
        XCTAssertTrue(saveSucc)
        
        let updatedCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "full_name='Test_5'")
        let update5 = updatedCustomer[0]
        let newPhone:String = update5.value(forKey: "phone_number") as! String
        XCTAssertEqual(testPhoneNum, newPhone)
    }
    
    func testDeleteData() throws {
        let allCustomer: [NSManagedObject] = sut.readData(by: "Customer")
        for oneCust in allCustomer {
            let full_name: String = oneCust.value(forKey: "full_name") as! String
            XCTAssertTrue(full_name.starts(with: "Test_"))
        }
        XCTAssertEqual(allCustomer.count, 5)
        let deledCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "id=1")
        sut.deleteData(targetObjs: deledCustomer)
        let emptyCustomer: [NSManagedObject] = sut.readData(name: "Customer", with: "id=1")
        XCTAssertTrue(emptyCustomer.count == 0)
    }
    
    func testSaveData() throws {
        _ = expectationForSaveNotification()
        guard let entityInst = sut.addNewToEntity(name: "Customer") else {
            XCTAssertTrue(false)
            return
        }
        entityInst.setValue(6, forKey: "id")
        entityInst.setValue("Test_6", forKey: "full_name")
        entityInst.setValue("666", forKey: "phone_number")
        entityInst.setValue("2019年5月1日", forKey: "birthday")
        entityInst.setValue(Date(), forKey: "created_at")
        //When save
        _ = sut.saveData()
        
        //Assert save is called via notification (wait)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func expectationForSaveNotification() -> XCTestExpectation {
            let expect = expectation(description: "Context Saved")
            waitForSavedNotification(completeHandler: { notify in
                expect.fulfill()
            })
            return expect
        }
}
