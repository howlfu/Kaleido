//
//  DemoSelectVMTest.swift
//  KaleidoTests
//
//  Created by Howlfu on 2022/3/10.
//

import XCTest
import CoreData
@testable import Kaleido

class DemoSelectMainVMTest: XCTestCase {
    var sut: DemoSelectMainViewModelTester!
    override func setUp() {
        super.setUp()
        sut = DemoSelectMainViewModelTester()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetOrderInforStr() throws {
        let orderContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let testOder = Order(context: orderContext)
        testOder.id = 12
        testOder.product_id = 19
        testOder.store_money = 100
        testOder.total_price = 50
        testOder.income = 10
        testOder.user_id = 16
        testOder.note = "Test Note 123"
        testOder.doer = "doer1"
        let productTypeContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let testProductType = ProductType(context: productTypeContext)
        testProductType.id = 1
        testProductType.ref_id_1 = 1
        testProductType.name = EntityNameDefine.productLashTop
        let lashTopContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let testProductLashTop = ProductLashTop(context: lashTopContext)
        testProductLashTop.id = 1
        testProductLashTop.type = "多層次"
        testProductLashTop.color = "彩色"
        testProductLashTop.top_size = "0.7"
        testProductLashTop.total_quantity = 300
        testProductLashTop.left_1 = "0.9L"
        testProductLashTop.right_2 = "0.9L"
        let customerContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let customerData = Customer(context: customerContext)
        customerData.id = 1
        customerData.remain_money = 500
        customerData.birthday = "1998/01/02"
        customerData.full_name = "test 1"
        customerData.phone_number = "12345678"
        customerData.created_at = Date()
        
        sut.setTestCustomer(data: customerData)
        sut.setTestProductType(data: testProductType)
        sut.setTestProductLashTop(data: testProductLashTop)
        
        let resultStr = sut.getOrderInforStr(data: testOder)
        let ansStr = "test 1, 1998/01/02\n上睫毛：\n多層次, 彩色, 0.7, 300根, \n左1: 0.9L, 右2: 0.9L, \n備註：Test Note 123, doer1"
        XCTAssertEqual(ansStr, resultStr)
    }
}
