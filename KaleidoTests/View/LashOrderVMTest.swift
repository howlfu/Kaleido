//
//  LashOrderVMTest.swift
//  KaleidoTests
//
//  Created by Howlfu on 2022/3/2.
//

import XCTest
import CoreData
@testable import Kaleido

class LashOrderVMTest: XCTestCase {
    var sut: LashOrderViewModel!
    override func setUp() {
        super.setUp()
        sut = LashOrderViewModel()
        sut.segmentToggleLeftClosure = { [weak self] isLeft in
            self!.closuerSegmentToggleLeft(isLeft: isLeft)
        }
        sut.notEndEdingClosure = { [weak self] textField in
            self!.closuerNotEndEding(target: textField)
        }
        
        sut.pickItemListClosure = { [weak self] in
            self!.closuerPickItemList()
        }
    }
    
    override func tearDown() {
        super.tearDown()
        sut.isLashTopEnable = false
        sut.isLashBottEnable = false
    }
    
    private func closuerSegmentToggleLeft(isLeft: Bool) {
        
    }
    
    private func closuerNotEndEding(target: Any) {
//        stopEditExp?.fulfill()
    }
    
    private func closuerPickItemList() {
        
    }
    
    //Test cases
    func testGetLashType() throws {
        let isResultEmpty = sut.getLashType() == ""
        XCTAssertTrue(isResultEmpty)
        sut.lashType = [LashListType.topLash, LashListType.bottLash]
        let eqStr = LashListType.topLash.rawValue + LashListTypePrefix + LashListType.bottLash.rawValue
        let resultStr = sut.getLashType()
        XCTAssertEqual(resultStr, eqStr)
    }
    
    func testSetOrderForDemo() throws {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let testOder = Order(context: childContext)
        testOder.id = 12
        testOder.product_id = 19
        testOder.store_money = 100
        testOder.total_price = 50
        testOder.income = 10
        testOder.user_id = 16
//        testOder.service_content = LashListType.topLash.rawValue
        sut.setOrderForDemo(data: testOder)
        let resultOrder = sut.orderOfCustomer
        XCTAssertEqual(testOder.id, resultOrder.id)
        XCTAssertEqual(testOder.product_id, resultOrder.product_id)
        XCTAssertEqual(testOder.store_money, resultOrder.store_money)
        XCTAssertEqual(testOder.total_price, resultOrder.total_price)
        XCTAssertEqual(testOder.income, resultOrder.income)
        XCTAssertEqual(testOder.user_id, resultOrder.user_id)
        
        XCTAssertEqual("", resultOrder.doer)
        XCTAssertEqual("", resultOrder.note)
        XCTAssertEqual("", resultOrder.services)
    }
    
    func testSetOrderInfo() throws {
        let testService = [LashListType.topLash]
        sut.setOrderInfo(lashTypeList: testService, cId: 1)
        let resultIsTop = sut.isLashTopEnable
        let resultIsBott = sut.isLashBottEnable
        XCTAssertTrue(resultIsTop)
        XCTAssertFalse(resultIsBott)
    }
    
    func testGetSelectStr() throws {
        sut.tmpCompNum = 2
        sut.getLashTopLenCurlFromDb()
        let retStr1 = sut.getSelectStr(row: 1, component: 0, exitStr: "123", target: "")
        XCTAssertEqual("B", retStr1)
        let retStr2 = sut.getSelectStr(row: 1, component: 1, exitStr: retStr1, target: "")
        XCTAssertEqual("B7", retStr2)
        sut.tmpCompNum = 2
        let retStr3 = sut.getSelectStr(row: 1, component: 1, exitStr: "123", target: "")
        XCTAssertEqual("7", retStr3)
        let retStr4 = sut.getSelectStr(row: 1, component: 0, exitStr: retStr3, target: "")
        XCTAssertEqual("B7", retStr4)
    }
    
}
