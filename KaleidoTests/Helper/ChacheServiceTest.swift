//
//  ChacheServerTest.swift
//  KaleidoTests
//
//  Created by Howlfu on 2022/3/11.
//

import XCTest
@testable import Kaleido

class ChacheServiceTest: XCTestCase {
    var sut: CacheService = CacheService.inst
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut.stop()
        super.tearDown()
    }
    
    func testStrCache() throws{
        let test1Str = "str1 for test"
        let testStrID = "testID1"
        sut.cacheNew(id: testStrID, object: test1Str)
        let test1Result = sut.getCache(by: testStrID) as! String
        XCTAssertEqual(test1Str, test1Result, "test value is string")
        let test2Str = "str2 for test"
        sut.cacheNew(id: testStrID, object: test2Str)
        let test2Result = sut.getCache(by: testStrID) as! String
        XCTAssertEqual(test2Str, test2Result, "test override")
        
        var removeResult = sut.cacheRemove(by: "test error id")
        XCTAssertFalse(removeResult, "test wrong id")
        removeResult = sut.cacheRemove(by: testStrID)
        XCTAssertTrue(removeResult, "test remove successful")
        let test3Result = sut.getCache(by: testStrID)
        XCTAssertNil(test3Result, "test get nil when nothing in cache")
        
        sut.cacheNew(id: testStrID, object: test1Str)
        sut.stop()
        let test4Result = sut.getCache(by: testStrID)
        XCTAssertNil(test4Result, "test get nil when nothing in cache")
    }
    
    func testObjectCache() throws{
        let test1Array = ["Test1", "Test2"]
        let test1StrID = "testID1"
        sut.cacheNew(id: test1StrID, object: test1Array)
        let test1Result = sut.getCache(by: test1StrID) as! Array<String>
        for (index, testItem) in test1Result.enumerated() {
            XCTAssertEqual(test1Array[index], testItem)
        }
        
        let test2Dict = ["key1": "value1", "key2": "value2"]
        let test2StrID = "testID2"
        sut.cacheNew(id: test2StrID, object: test2Dict)
        let test2Result = sut.getCache(by: test1StrID) as? Dictionary<String, String>
        XCTAssertNil(test2Result)
        let test3Result = sut.getCache(by: test2StrID) as! Dictionary<String, String>
        for testDictItem in test3Result.keys {
            XCTAssertEqual(test2Dict[testDictItem], test3Result[testDictItem])
        }
    }
//    
//    func testHibridCache() throws{
//    }
}
