//
//  BillCheckVMTest.swift
//  KaleidoTests
//
//  Created by Howlfu on 2022/3/7.
//

import XCTest
@testable import Kaleido

class BillCheckVMTest: XCTestCase {
    var sut: BillCheckViewModel!
    override func setUp() {
        super.setUp()
        sut = BillCheckViewModel()
        sut.start()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetPayMethodName() throws {
        
        let payMethods = sut.getPayMethod()
        for (_, index) in payMethods {
            let testSelIndex = IndexPath(row: Int(index), section: 1)
            sut.paymethodSelectIndex = testSelIndex
            let retName = sut.getPayMethodName()
            XCTAssertTrue(payMethods.keys.contains(retName))
        }
    }
    
    func testgetProfit() throws {
        var profit = sut.getProfit()
        XCTAssertNotNil(profit, "no profit")
        sut.currentProfit = 100
        profit = sut.getProfit()
        XCTAssertEqual(100, profit)
    }
    
    func testGetStoreRule() throws {
        let rules = sut.getStoreRule()
        XCTAssertNotNil(rules, "default rules")
    }
    
    func testGetCalcResult() throws {
        let sutTester = BillCheckViewModelTester()
        sutTester.start()
        //決定儲值金額
//        sut.selectedDiscountRuleId = 0
        //決定哪一種付款方式
//        sut.paymethodSelectIndex = 0
        sutTester.orderOfCustomer = OrderEntityType(id: 1, doer: "tester", note: "456", pay_method: "", product_id: 1, store_money: 0, total_price: 0, income: 0, user_id: 1, created_date: Date(), services: "上睫毛")
        var resultShouldPay = sutTester.getCalcResult(price: "2000", shouldSave: false)
        XCTAssertEqual(2000, resultShouldPay, "test default should pay")
        sutTester.setCustDiscountRuleId = 1
        sutTester.selectedDiscountRuleId = 1
        resultShouldPay = sutTester.getCalcResult(price: "2000", shouldSave: false)
        XCTAssertEqual(0, resultShouldPay, "test store 3000")
        
        sutTester.selectedDiscountRuleId = 1
        resultShouldPay = sutTester.getCalcResult(price: "2000", shouldSave: true)
        var profit = sutTester.currentProfit
        XCTAssertEqual(0, resultShouldPay, "test store 3000")
        XCTAssertEqual(1818, profit, "test profit should be 3000 * 0.909")
        
        sutTester.selectedDiscountRuleId = nil //did not store money
        resultShouldPay = sutTester.getCalcResult(price: "1500", shouldSave: true)
        profit = sutTester.currentProfit
        XCTAssertEqual(200, resultShouldPay, "test remain 1300 and should pay 200")
        XCTAssertEqual(1381, profit, "test profit 200 + 1300 * 0.909")
        sutTester.selectedDiscountRuleId = 1
        sutTester.setCustDiscountRuleId = 1
        //save 3000 remain 300
        resultShouldPay = sutTester.getCalcResult(price: "2000", shouldSave: true)
        sutTester.selectedDiscountRuleId = 1
        sutTester.setCustDiscountRuleId = 1
        let _ = sutTester.getCurrentRemainMoney()
        //save 6000 + org 1300 to calulate 5000 result
        sutTester.selectedDiscountRuleId = 2
        sutTester.setCustDiscountRuleId = 2
        resultShouldPay = sutTester.getCalcResult(price: "5000", shouldSave: true)
        profit = sutTester.currentProfit //4446
        let remainMoney = sutTester.getCurrentRemainMoney() //3100
        XCTAssertEqual(3100, remainMoney, "test remain money 6800 - 3700")
        XCTAssertEqual(4445, profit, "test profit 1300 * 0.909 + 3700 * 0.8823")
    }
    
}
